package agilesitesng.deploy.actor

import akka.actor.{ActorLogging, Actor, Props}
import akka.io.IO
import spray.http.HttpHeaders.Cookie

/**
  * Created by msciab on 25/08/16.
  */
object Notifier {

  import DeployProtocol._

  def actor() = Props(classOf[NotifierActor])

  class NotifierActor
    extends Actor
      with ActorLogging
      with ActorUtils {

    def receive = {
      case Notify(msg: String) =>
        println(s"[${msg}]")
    }
  }
}
