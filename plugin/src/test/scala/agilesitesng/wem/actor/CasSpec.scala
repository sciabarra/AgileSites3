package agilesitesng.wem.actor

import akka.actor.ActorSystem
import akka.pattern.ask
import akka.testkit.{TestActorRef, TestKit}
import akka.util.Timeout
import com.typesafe.config.ConfigFactory
import org.scalatest.{BeforeAndAfterAll, MustMatchers, WordSpecLike}

import scala.concurrent.Await
import scala.concurrent.duration._

/**
 * Created by msciab on 25/04/15.
 */
class CasSpec extends TestKit(ActorSystem("sbt-web", ConfigFactory.load().getConfig("sbt-web")))
with WordSpecLike
with MustMatchers
with BeforeAndAfterAll {
  override def afterAll = TestKit.shutdownActorSystem(system)

  import Cas._
  import Protocol._

  val cas = TestActorRef[CasActor]

  val config = testKitSettings.config

  "cas" in {
    implicit val timeout = Timeout(3.second)

    val url = new java.net.URL(config.getString("sites.url"))
    val user = config.getString("sites.user")
    val pass = config.getString("sites.pass")

    val f = cas ? Connect(Some(url), Some(user), Some(pass))
    val Ticket(ticket) = Await.result(f, 3.second).asInstanceOf[Ticket]
    info(ticket)
  }
}