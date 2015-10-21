package agilesitesng

import com.typesafe.config.ConfigFactory
import net.liftweb.json._
import agilesitesng.wem.actor.Protocol._
import agilesitesng.wem.actor.{Protocol, Hub}
import akka.actor.ActorSystem
import akka.pattern.ask

import scala.concurrent.Await
import scala.concurrent.duration._
import akka.util.Timeout

/**
 * Created by msciab on 19/10/15.
 */
object AgileSitesNgInstall extends App {

  implicit val timeout = Timeout(3.second)
  val config = ConfigFactory.load().getConfig("sbt-web")

  val url = new java.net.URL(config.getString("sites.url"))
  val user = config.getString("sites.user")
  val password = config.getString("sites.pass")

  val system = ActorSystem("sbt-web", config)
  val hub = system.actorOf(Hub.actor(), "Hub")

  val f = hub ? Protocol.Connect(Some(url), Some(user), Some(password))
  val result = Await.result(f, timeout.duration)
  result match {
    case Status(OK, res) =>
      val msg = Get("/sites")

      println(">>> sending " + msg.toString)
      val rf = hub ? msg
      val Reply(json) = Await.result(rf, timeout.duration).asInstanceOf[Reply]

      val res = pretty(render(json))
      println("<<< received " + res)

      Await.result(hub ? Disconnect(), timeout.duration)

    case _ =>
      println("Timeout")
  }
  system.shutdown()

}
