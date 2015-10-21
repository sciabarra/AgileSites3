package agilesitesng

import net.liftweb.json._
import agilesitesng.wem.actor.Protocol.Reply
import agilesitesng.wem.actor.{Protocol, Hub}
import akka.actor.ActorSystem
import akka.util.Timeout
import akka.pattern.ask

import scala.concurrent.Await
import scala.concurrent.duration._

/**
 * Created by msciab on 19/10/15.
 */
object AgileSitesNgInstall extends App {

  val url = new java.net.URL("http://10.0.2.15:7003/sites/")
  val user = "fwadmin"
  val password = "xceladmin"

  val system = ActorSystem("sbt-web")
  val hub = system.actorOf(Hub.actor(), "Hub")

  val f = hub ! Protocol.Connect(Some(url), Some(user), Some(password))

  val msg = "/sites"
  println(">>> sending " + msg.toString)

  implicit val timeout = Timeout(3.second)
  val rf = hub ? msg
  val Reply(json) = Await.result(rf, 3.second).asInstanceOf[Reply]
  val res = pretty(render(json))
  println("<<< received " + res)

}
