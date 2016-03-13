package agilesitesng.deploy.actor

import java.net.URL

import spray.http._
import akka.io.IO
import agilesitesng.wem.actor.Protocol.WemMsg
import akka.actor.{ActorRef, ActorLogging, Actor, Props}
import akka.event.LoggingAdapter
import akka.util.ByteStringBuilder
import spray.http.HttpHeaders.{Cookie, `Set-Cookie`}
import spray.http.Uri.{Query, Path, Host, Authority}
import spray.httpx.RequestBuilding._

/**
 * Created by msciab on 21/11/15.
 */
object Services {

  import DeployProtocol._

  def actor() = Props(classOf[ServicesActor])

  // build a get request
  def buildGet(op: String, params: Tuple2[String, String]*)
              (url: URL, cookie: Cookie, log: LoggingAdapter) =
    buildGetMap(op, params.toMap)(url, cookie, log)

  // build a get request out of a map
  def buildGetMap(op: String, params: Map[String, String])
                 (url: URL, cookie: Cookie, log: LoggingAdapter) = {
    val uri = Uri(url.getProtocol,
      authority = Authority(Host(url.getHost), url.getPort),
      path = Path(url.getPath + "/ContentServer"),
      query = Query(params + ("pagename" -> "AAAgileService") + ("op" -> op) + ("d" -> "")))
    val req = Get(uri) ~> addHeaders(cookie)
    //println(req.toString)
    log.debug(req.toString)
    req
  }

  def buildPostMap(op: String, params: Map[String, String])
                  (url: URL, cookie: Cookie, authKey: String, log: LoggingAdapter) = {
    val uri = Uri(url.getProtocol,
      authority = Authority(Host(url.getHost), url.getPort),
      path = Path(url.getPath + "/ContentServer"))
    val data = params.toSeq ++
      Seq("pagename" -> "AAAgileService", "op" -> op, "_authkey_" -> authKey.trim)
    val req = Post(uri, FormData(data)) ~> addHeaders(cookie)
    log.debug(req.toString)
    req
  }

  class ServicesActor
    extends Actor
    with ActorLogging
    with ActorUtils {

    implicit val system = context.system
    val http = IO(spray.can.Http)
    var url: java.net.URL = null
    var cookie = Cookie(Seq())
    var authKey = Option.empty[String]

    def receive = {

      case ServiceLogin(_url, username, password) =>
        if (authKey.nonEmpty) {
          context.sender ! ServiceReply("OK - already logged in")
        } else {
          url = _url
          http ! buildGet("login", "username" -> username,
            "password" -> password)(url, cookie, log)
          log.debug(s"${username}/${password} -> ${url}")
          context.become(waitForHttpReply(context.sender))
        }

      case ServiceLogout() =>
        log.debug("logging out")
        authKey = None

      case ServiceGet(args) =>
        val op = args.get("op")
        log.debug(s"op=${op}")
        if (op.isEmpty) {
          log.info(s"sender ${context.sender}")
          context.sender ! ServiceReply("ERROR: missing op")
        } else {
          http ! buildGetMap(op.get, args - "op")(url, cookie, log)
          context.become(waitForHttpReply(context.sender))
        }

      case ServicePost(args) =>
        log.debug(args.toString)
        val op = args.get("op")
        if (op.isEmpty) {
          sender ! ServiceReply("ERROR: missing op")
        } else {
          http ! buildPostMap(op.get, args - "op")(url, cookie, authKey.get, log)
          context.become(waitForHttpReply(context.sender))
        }
    }

    var chunkedResponse: HttpResponse = null
    var chunkCollector: ByteStringBuilder = null

    /** Process requests - either normal and authentication */
    def processRequest(origin: ActorRef, res: HttpResponse, body: String) = {
      log.debug(s"Process Request: ${body}")
      if (authKey.nonEmpty) {
        //println(s"Sending ${origin} !${body}")
        // we are running request/response loop
        origin ! ServiceReply(body)
        context.unbecome()
        flushQueue
      } else {
        val headers = res.headers
        if (cookie.cookies.isEmpty) {
          val cookies = headers.filter(_.isInstanceOf[`Set-Cookie`]).map(_.asInstanceOf[`Set-Cookie`].cookie).toSeq
          log.debug(cookies.toString)
          if (cookies.isEmpty) {
            origin ! ServiceReply(s"KO code=${body} cookies=${cookies.mkString(";")}")
            context.unbecome()
          } else {
            cookie = Cookie(cookies)
            http ! buildGet("authkey")(url, cookie, log)
          }
        } else {
          // got cookie, looking for authkey
          authKey = Some(body)
          origin ! ServiceReply(s"OK ${authKey}")
          context.unbecome()
          flushQueue
        }
      }
    }

    def waitForHttpReply(ref: ActorRef): Receive = {
      case ChunkedResponseStart(res) =>
        chunkCollector = new ByteStringBuilder
        chunkedResponse = res

      case MessageChunk(data, _) =>
        //print(".")
        chunkCollector ++= data.toByteString

      case ChunkedMessageEnd(_, _) =>
        val body = chunkCollector.result.decodeString("UTF-8")
        processRequest(ref, chunkedResponse, body)

      case res: HttpResponse =>
        val body = res.entity.asString
        ref ! ServiceReply(body)
        context.unbecome()
        flushQueue

      case msg: WemMsg =>
        enqueue(msg)
    }

  }

}