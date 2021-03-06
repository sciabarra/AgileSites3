package agilesitesng.wem.actor

import agilesitesng.wem.actor.Protocol.{Ticket, Connect}
import akka.actor.{ActorRef, ActorLogging, Actor, Props}
import akka.event.LoggingReceive
import akka.io.IO
import akka.util.ByteStringBuilder
import spray.http._
import spray.http.Uri.{Path, Host, Authority}
import spray.httpx.RequestBuilding._

/**
 * Created by msciab on 25/07/15.
 */
object Cas {

  def actor() = Props[CasActor]

  class CasActor extends Actor with ActorLogging {

    implicit val system = context.system
    val http = IO(spray.can.Http)
    var requester: ActorRef = null

    //var chunkedResponse: HttpResponse = null
    var chunkCollector: ByteStringBuilder = null

    var location = Option.empty[HttpHeader]

    def processRequest(ticket: String) {
      if (location.nonEmpty) {
        http ! Post(Uri(location.get.value), FormData(Seq("service" -> "*")))
        log.debug("Reply with Location {}", location.get.value)
      } else {
        log.debug("Reply with Ticket {}", ticket)
        println(ticket)
        requester ! Ticket(ticket)
      }
    }

    def receive = LoggingReceive {
      case Connect(url, username, password) =>

        val jnu = url getOrElse new java.net.URL(context.system.settings.config.getString("akka.sites.url"))
        val user = username getOrElse context.system.settings.config.getString("akka.sites.user")
        val pass = password getOrElse system.settings.config.getString("akka.sites.pass")
        val host = Authority(Host(jnu.getHost), jnu.getPort)
        val uri = Uri(jnu.getProtocol, authority = host, path = Path("/cas/v1/tickets"))
        val data = FormData(Seq("username" -> user, "password" -> pass))
        log.debug(s"sending a message to http ${uri}, ${data}, ${http}")
        http ! Post(uri, data)
        requester = context.sender()

      case ChunkedResponseStart(res) =>
        location = res.headers.filter(_.name == "Location").headOption
        chunkCollector = new ByteStringBuilder

      case MessageChunk(data, _) =>
        chunkCollector ++= data.toByteString

      case ChunkedMessageEnd(_, _) =>
        processRequest(chunkCollector.result.decodeString("UTF-8"))

      case res: HttpResponse =>
        location = res.headers.filter(_.name == "Location").headOption
        log.debug("HttpResponse Location: {} ", location)
        processRequest(res.entity.asString)

      case wtf => log.debug(wtf.toString)
    }
  }

}
