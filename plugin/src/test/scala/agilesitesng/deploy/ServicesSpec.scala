package agilesitesng.deploy

import java.net.URL

import akka.actor.ActorSystem
import akka.pattern.ask
import akka.testkit.{TestActorRef, TestKit}
import akka.util.Timeout
import com.typesafe.config.ConfigFactory
import org.scalatest.{BeforeAndAfterAll, MustMatchers, WordSpecLike}
import agilesitesng.deploy.actor.Services
import agilesitesng.deploy.actor.DeployProtocol
import scala.concurrent.Await
import scala.concurrent.duration._
import scala.util.Success

/**
 * Created by msciab on 25/04/15.
 */
class ServicesSpec extends TestKit(ActorSystem("sbt-web", ConfigFactory.load().getConfig("sbt-web")))
with WordSpecLike
with MustMatchers
with BeforeAndAfterAll {
  override def afterAll = TestKit.shutdownActorSystem(system)

  val svc = TestActorRef[Services.ServicesActor]

  val config = testKitSettings.config

  /*
  "login" in {
    implicit val timeout = Timeout(3.second)

    import DeployProtocol._
    val url = new URL("http://10.0.2.15:7003/sites")
    svc ! Ask(testActor, ServiceLogin(url, "fwadmin", "xceladmin"))
    expectMsgPF(timeout.duration) {
      case ServiceReply(s) =>

        val f = svc ? ServiceGet(Map("err" -> "version"))
        val r = Await.result(f, timeout.duration).asInstanceOf[ServiceReply]
        r.result must startWith("ERROR:")

        val f1 = svc ? ServiceGet(Map("op" -> "version"))
        val r1 = Await.result(f1, timeout.duration).asInstanceOf[ServiceReply]
        info(r1.toString)
        r1.result must startWith("Concat ")

        val f2 = svc ? ServicePost(Map("op" -> "version"))
        val r2 = Await.result(f2, timeout.duration).asInstanceOf[ServiceReply]
        info(r2.toString)
        r2.result must startWith("Concat ")

      //expectMsgPF(timeout.duration) {
      //  case x: Any => info(x.toString)
      //}
    }
  }
*/

  "synclogin" in {
    implicit val timeout = Timeout(10.second)
    val dur = timeout.duration
    import DeployProtocol._
    val url = new URL("http://10.0.2.15:7003/sites")
    val user = "fwawmin"
    val pass = "xceladmin"

    val f = svc ? ServiceLogin(url, user, pass)
    val r = Await.result(f, dur).asInstanceOf[ServiceReply] match {
      case SimpleServiceReply(res) => println(s"${res}"); info(res)
      case _ => println("wrong service reply type: expected PrintServiceReply")
    }

    val f1 = svc ? ServiceGet(Map("op" -> "version"))
    val r1 = Await.result(f1, timeout.duration).asInstanceOf[ServiceReply] match {
      case SimpleServiceReply(res) => println(s"${res}"); res must startWith("Concat ")
      case _ => println("wrong service reply type: expected PrintServiceReply")
    }
    info(r1.toString)

    svc ! ServiceLogout()
  }


}