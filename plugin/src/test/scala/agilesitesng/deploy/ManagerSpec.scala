package agilesitesng.deploy

import java.net.URL

import agilesitesng.deploy.actor.{DeployProtocol, Services}
import akka.actor.ActorSystem
import akka.pattern.ask
import akka.testkit.{TestActorRef, TestKit}
import akka.util.Timeout
import com.typesafe.config.ConfigFactory
import org.scalatest.{BeforeAndAfterAll, MustMatchers, WordSpecLike}

import scala.concurrent.Await
import scala.concurrent.duration._
import agilesitesng.deploy.actor.Manager

/**
 * Created by msciab on 25/04/15.
 */
class ManagerSpec extends TestKit(ActorSystem("sbt-web", ConfigFactory.load().getConfig("sbt-web")))
with WordSpecLike
with MustMatchers
with BeforeAndAfterAll {
  override def afterAll = TestKit.shutdownActorSystem(system)


  val config = testKitSettings.config

  "hello" in {
    implicit val timeout = Timeout(3.second)
    import DeployProtocol._

    val url = new URL("http://10.0.2.15:7003/sites")
    val user = "fwadmin"
    val passwd = "xceladmin"

    val manager = system.actorOf(Manager.actor(url, user, passwd))
    manager ? ServiceGet(Map("op" -> "hello"))
    /*
    val f2 = manager ? ServiceGet(Map("op" -> "hello"))
    val r2 = Await.result(f2, timeout.duration).asInstanceOf[ServiceReply]
    info(r2.toString)
    */

  }
}