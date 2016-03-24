package agilesitesng.deploy.actor

import java.io.File
import java.net.URL

import akka.util.Timeout
import spoon.Launcher
import agilesitesng.deploy.model.SpoonModel
import agilesitesng.wem.actor.Protocol.Post

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

  def actor(services: ActorRef, timeOut: Int) = Props(classOf[CollectorActor], services, timeOut)

  class CollectorActor(services: ActorRef, timeOut: Int)
    extends Actor
    with ActorLogging
    with ActorUtils {

    implicit val timeout = Timeout(timeOut.seconds)

    var decoder: Option[Decoder] = None

    def receive: Receive = LoggingReceive {

      case SpoonBegin(url: URL, site: String, user: String, pass: String, map: Map[String,String]) =>
        log.debug(s">>> collector begin: ${url} ${map}")
        decoder = Some(new Decoder(site, user, pass, map))

      case SpoonData(model) =>
        if (decoder.nonEmpty) {
          val map = decoder.get(model)
          log.debug(s">>> collector data: ${map} ---")
          val f = services ? ServicePost(map)
          Await.result(f, timeOut.seconds).asInstanceOf[ServiceReply] match {
            case SimpleServiceReply(res) => log.debug(res)
            case _ => log.error("wrong service reply type: expected PrintServiceReply")
          }

        } else {
          log.warning("dropping request as  decoder not initialized")
        }

      case SpoonEnd(args) =>
        log.debug(">>> collector end.")

    }
  }

}
