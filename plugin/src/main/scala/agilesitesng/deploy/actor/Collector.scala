package agilesitesng.deploy.actor

import java.io.File
import java.net.URL

import spoon.Launcher
import agilesitesng.deploy.model.SpoonModel

import akka.actor._
import akka.event.LoggingReceive
import scala.collection.{mutable, JavaConversions}

import scala.concurrent.Await
import scala.concurrent.duration._
import akka.pattern.ask

/**
 * Created by msciab on 05/08/15.
 */
object Collector {

  import DeployProtocol._

  def actor(services: ActorRef) = Props(classOf[CollectorActor], services)

  class CollectorActor(services: ActorRef)
    extends Actor
    with ActorLogging
    with ActorUtils {

    var decoder: Option[Decoder] = None
    var requester: Option[ActorRef] = None

    def receive: Receive = LoggingReceive {

      case SpoonBegin(url: URL, site: String, user: String, pass: String, map: Map[String,String]) =>
        log.debug(s">>> collector begin: ${url} ${map}")
        decoder = Some(new Decoder(site, user, pass, map))
        requester = Some(context.sender)

      case SpoonData(model) =>
        if (decoder.nonEmpty) {
          val map = decoder.get(model)
          log.debug(s">>> collector data: ${map} ---")
          services ! ServicePost(map)
        } else {
          log.warning("dropping request as  decoder not initialized")
        }

      case SpoonEnd(args) =>
        log.debug(">>> collector end.")

      case ServiceReply(msg) =>
        log.debug(s"<<< collector reply:")
        if (requester.nonEmpty)
          requester.get ! SpoonReply(msg)
        else
          log.warning("dropping reply as requester not initialized")
    }
  }

}
