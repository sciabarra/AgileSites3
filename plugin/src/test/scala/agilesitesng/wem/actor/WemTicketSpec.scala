package agilesitesng.wem.actor

import java.net.URL

import agilesitesng.wem.actor.Cas.CasActor
import agilesitesng.wem.actor.Protocol.{Ticket, Connect}
import akka.actor.ActorSystem
import akka.testkit.{TestActorRef, TestKit}
import akka.util.Timeout
import com.typesafe.config.ConfigFactory
import net.liftweb.json._
import org.scalatest.{BeforeAndAfterAll, MustMatchers, WordSpecLike}

import scala.concurrent.Await
import scala.concurrent.duration._
import akka.pattern.ask


/**
 * Created by msciab on 25/04/15.
 */
class WemTicketSpec
  extends TestKit(ActorSystem("sbt-web", ConfigFactory.load().getConfig("sbt-web")))
  with WordSpecLike
  with MustMatchers
  with BeforeAndAfterAll {
  override def afterAll = TestKit.shutdownActorSystem(system)

   implicit val timeout = Timeout(3.second)
  val url = Some(new URL("http://10.0.2.15/sites"))
  val cas = TestActorRef[CasActor]
  val f = cas ? Connect(url, Some("fwadmin"), Some("xceladmin"))
  val Ticket(ticket) = Await.result(f, 3.second).asInstanceOf[Ticket]

  "wem" in {

    val wem = TestActorRef(WemTicket.actor(ticket, url))
    wem ! Protocol.WemGet(testActor, "/sites")
    expectMsgPF(5.second) {
      case Protocol.Reply(json) => info(pretty(render(json)))
    }
  }
}