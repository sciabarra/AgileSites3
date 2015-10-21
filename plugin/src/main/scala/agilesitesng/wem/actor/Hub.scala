package agilesitesng.wem.actor

import agilesitesng.wem.actor.Cas.Cas1Actor
import agilesitesng.wem.actor.Protocol.Connect
import akka.actor._
import akka.event.LoggingReceive
import net.liftweb.json._

import scala.collection.mutable

/**
 * Created by msciab on 26/04/15.
 */
object Hub {

  def actor() = Props[HubActor]

  class HubActor extends Actor with ActorLogging with Queuer {

    import Protocol._

    var url: Option[java.net.URL] = None

    val casActor = context.actorOf(Cas.actor())

    def receive = preLogin

    def preLogin: Receive = LoggingReceive {
      case msg@Connect(url, user, pass) =>
        this.url = url
        casActor ! msg
        context.become(waitForId(sender))
    }

    def waitForId(requestor: ActorRef) = LoggingReceive {
      case Ticket(ticket) =>
        log.info("creating a WemTicket actor")
        val wem = context.actorOf(WemTicket.actor(ticket, url))
        context.become(running(wem))
        requestor ! Status(OK)
        flushQueue

      case msg: Message => enqueue(msg)
    }


    def running(wem: ActorRef): Receive = LoggingReceive {
      case Get(request) =>
        val sender = context.sender()
        wem ! WemGet(sender, request)

      case Delete(request) =>
        val sender = context.sender()
        wem ! WemDelete(sender, request)

      case Post(request, json) =>
        val sender = context.sender()
        val sjson = pretty(render(json))

        if (sjson.isEmpty) {
          sender ! Protocol.Reply(JString("error: empty post"))
          log.debug("Post with empty body")
        } else {
          log.debug("Post {} sender {} json {}", request, sender, json)
          wem ! WemPost(sender, request, sjson)
        }

      case Put(request, json) =>
        val sender = context.sender()
        val sjson = pretty(render(json))
        if (sjson.isEmpty) {
          sender ! Protocol.Reply(JString("error: empty post"))
          log.debug("Put with empty body")
        } else {
          log.debug("Put {} sender {}", request, sender)
          wem ! WemPut(sender, request, sjson)
        }

      case Disconnect() =>
        wem ! PoisonPill
        context.become(preLogin)
        sender ! Status(OK)
    }

  }

}
