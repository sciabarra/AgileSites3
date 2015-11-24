package agilesitesng.deploy

import agilesitesng.deploy.NgDeployKeys._
import agilesites.config.AgileSitesConfigKeys._

import agilesitesng.deploy.actor.DeployProtocol.{ServiceLogin, ServiceReply, ServiceGet}
import agilesitesng.deploy.actor.Services
import akka.util.Timeout
import com.typesafe.sbt.web.SbtWeb
import sbt.{Project, Extracted, Def, Command}
import akka.pattern.ask

import scala.concurrent.Await
import scala.concurrent.duration._
import sbt._,Keys._

/**
 * Created by msciab on 24/11/15.
 */
trait ActorCommand {
  implicit val timeout = Timeout(10.seconds)

  def serviceCmd = Command.args("nservice", "<args>") { (state, args) =>

    if (args.size == 0) {
      println("usage: ng:service <op> <key=value>")
      "no args"
    } else {
      // input hello 0 a=1 b=2
      val opts = args.tail.map(s => if (s.indexOf("=") == -1) "value=" + s else s)
      // output List("value=0", "a=1", "b=2")
      val map = opts.map(_.split("=")).map(x => x(0) -> x(1)).toMap
      // output Map("value"->"0" "a" -> "1", "b" -> "2")

      // retrieve parameters
      val extracted: Extracted = Project.extract(state)
      val url = new java.net.URL((sitesUrl in extracted.currentRef get extracted.structure.data).get)
      val user = (sitesUser in extracted.currentRef get extracted.structure.data).get
      val password = (sitesPassword in extracted.currentRef get extracted.structure.data).get

      SbtWeb.withActorRefFactory(state, "Ng") {
        arf =>
          val svc = arf.actorOf(Services.actor())
          val r = Await.result(svc ? ServiceLogin(url, user, password), 10.second)

          var req = ServiceGet(map)
          println(s">>>" + req)
          val ServiceReply(res) = Await.result(svc ? req, 10.second).asInstanceOf[ServiceReply]
          println("<<< ${res}")
      }
    }
    state
  }

  val actorCommand = Seq(commands += serviceCmd )
}
