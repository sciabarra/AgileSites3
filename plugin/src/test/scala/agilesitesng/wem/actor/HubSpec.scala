package agilesitesng.wem.actor

import akka.actor.ActorSystem
import akka.pattern.ask
import akka.testkit.{TestActorRef, TestKit}
import akka.util.Timeout
import com.typesafe.config.ConfigFactory
import org.scalatest.{BeforeAndAfterAll, MustMatchers, WordSpecLike}

import scala.concurrent.Await
import scala.concurrent.duration._
import net.liftweb.json._

/**
 * Created by msciab on 25/04/15.
 */
class HubSpec
  extends TestKit(ActorSystem("sbt-web", ConfigFactory.load().getConfig("sbt-web")))
  with WordSpecLike
  with MustMatchers
  with BeforeAndAfterAll {
  override def afterAll = TestKit.shutdownActorSystem(system)

  import Hub._
  import Protocol._

  val config = testKitSettings.config
  val hub = TestActorRef[HubActor]
  val url = new java.net.URL(config.getString("sites.url"))
  val user = config.getString("sites.user")
  val pass = config.getString("sites.pass")

  val s3 = 3.second
  implicit val timeout = Timeout(s3)

  "hub" in {

    val f = hub ? Connect(Some(url), Some(user), Some(pass))
    Await.result(f, s3) === Status(OK)

    val Reply(json) = Await.result(hub ? Get("/sites"), s3)
    info(pretty(render(json)))

    Await.result(hub ? Disconnect(), s3) === Status(OK)

  }

}