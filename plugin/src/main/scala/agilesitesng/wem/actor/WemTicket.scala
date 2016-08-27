package agilesitesng.wem.actor

import agilesitesng.wem.actor.Protocol.{WemMsg, WemGet, WemPut, WemPost, WemDelete}
import akka.actor.{Actor, ActorLogging, ActorRef, Props}
import akka.event.LoggingReceive
import akka.io.IO
import net.liftweb.json._
import spray.http._
import spray.httpx.RequestBuilding._
import akka.util._

/**
  * Created by msciab on 25/04/15.
  */
object WemTicket {

  def actor(ticket: String, url: Option[java.net.URL] = None) = Props(classOf[WemActor], ticket, url)

  class WemActor(ticket: String, url: Option[java.net.URL] = None)
    extends Actor
      with Queuer
      with ActorLogging {

    implicit val system = context.system
    val http = IO(spray.can.Http)
    val jnu = url getOrElse new java.net.URL(context.system.settings.config.getString("akka.sites.url"))

    def uri(what: String) = {
      if (what.startsWith("?")) {
        s"${jnu.toString}/ContentServer${what}"
      } else {
        val sep = if (what.indexOf("?") == -1) "?" else "&"
        s"${jnu.toString}/REST${what}${sep}multiticket=${ticket}"
      }
    }

    import agilesites.AgileSitesConstants.is11g

    def receive: Receive = LoggingReceive {

      case WemGet(ref, what) =>
        val req = if (is11g) {
          Get(Uri(uri(what))) ~>
            addHeader("X-CSRF-Token", ticket) ~>
            addHeader("Accept", "application/json")
        } else {
          Get(Uri(uri(what))) ~>
            addHeader("Accept", "application/json")
        }

        log.debug("get {}", req.toString)
        http ! req
        context.become(waitForHttpReply(ref), false)

      case WemDelete(ref, what) =>
        val req = if (is11g) {
          Delete(Uri(uri(what))) ~>
            addHeader("X-CSRF-Token", ticket) ~> // for 11g
            addHeader("Accept", "application/json")
        } else {
          Delete(Uri(uri(what))) ~>
            addHeader("Accept", "application/json")
        }
        log.debug("delete {}", req.toString)
        http ! req
        context.become(waitForHttpReply(ref), false)

      case WemPost(ref, what, body) =>
        val req = if (is11g) {
          HttpRequest(method = HttpMethods.POST, uri = uri(what),
            entity = HttpEntity(ContentTypes.`application/json`, body)) ~>
            addHeader("X-CSRF-Token", ticket) ~> // for 11g
            addHeader("Accept", "application/json")
        } else {
          HttpRequest(method = HttpMethods.POST, uri = uri(what),
            entity = HttpEntity(ContentTypes.`application/json`, body)) ~>
            addHeader("Accept", "application/json")
        }
        log.debug("post {}", req.toString)
        http ! req
        context.become(waitForHttpReply(ref), false)

      case WemPut(ref, what, body) =>
        val req =
          if (is11g) {
            HttpRequest(method = HttpMethods.PUT, uri = uri(what),
              entity = HttpEntity(ContentTypes.`application/json`, body)) ~>
              addHeader("X-CSRF-Token", ticket) ~>
              addHeader("Accept", "application/json")
          } else {
            HttpRequest(method = HttpMethods.PUT, uri = uri(what),
              entity = HttpEntity(ContentTypes.`application/json`, body)) ~>
              addHeader("Accept", "application/json")
          }
        log.debug("put {}", req.toString)
        http ! req
        context.become(waitForHttpReply(ref), false)
    }

    var chunkedResponse: HttpResponse = null
    var chunkCollector: ByteStringBuilder = null

    def completeHttpRequest(ref: ActorRef, body: String, res: HttpResponse): Unit = {
      val json = try {
        parse(body)
      } catch {
        case e: Throwable =>
          parse( s"""{ "error": "${res.message}" } """)
      }
      ref ! Protocol.Reply(json, res.status.intValue)
      context.unbecome()
      flushQueue
    }

    def waitForHttpReply(ref: ActorRef): Receive = {
      case ChunkedResponseStart(res) =>
        chunkCollector = new ByteStringBuilder
        chunkedResponse = res

      case MessageChunk(data, _) =>
        chunkCollector ++= data.toByteString

      case ChunkedMessageEnd(_, _) =>
        val body = chunkCollector.result.decodeString("UTF-8")
        completeHttpRequest(ref, body, chunkedResponse)

      case res: HttpResponse =>
        val body = res.entity.asString
        completeHttpRequest(ref, body, res)

      case msg: WemMsg =>
        enqueue(msg)
    }

  }

}
