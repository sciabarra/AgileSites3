package agilesitesng.deploy

import agilesitesng.deploy.NgDeployKeys._
import agilesites.config.AgileSitesConfigKeys._

import agilesitesng.deploy.actor.DeployProtocol._
import agilesitesng.deploy.actor.{Collector, Services}
import agilesitesng.deploy.model.Spooler
import akka.actor.ActorRef
import akka.util.Timeout
import com.typesafe.sbt.web.SbtWeb
import sbt._
import akka.pattern.ask

import scala.concurrent.Await
import scala.concurrent.duration._
import Keys._
import agilesites.Utils

/**
 * Created by msciab on 24/11/15.
 */
trait ActorCommands {
  this: AutoPlugin with Utils =>

  implicit val myTimeout = Timeout(10.seconds)

  def login(svc: ActorRef, state: State): (URL, String, String, String) = {
    // login into services
    val extracted: Extracted = Project.extract(state)
    val url = new java.net.URL((sitesUrl in extracted.currentRef get extracted.structure.data).get)
    val user = (sitesUser in extracted.currentRef get extracted.structure.data).get
    val password = (sitesPassword in extracted.currentRef get extracted.structure.data).get
    val focus = (sitesFocus in extracted.currentRef get extracted.structure.data).get
    Await.result(svc ? ServiceLogin(url, user, password), 10.second)
    (url, focus, user, password)
  }

  def serviceCmd = Command.args("nservice", "<args>") { (state, args) =>

    if (args.size == 0) {
      println("usage: ng:service <op> <key=value>")
      "no args"
    } else {

      // input hello 0 a=1 b=2
      val opts = args.map(s => if (s.indexOf("=") == -1) "value=" + s else s)
      // output List("value=0", "a=1", "b=2")
      val map = opts.tail.map(_.split("=")).map(x => x(0) -> x(1)).toMap + ("op" -> args.head)
      // output Map("value"->"0" "a" -> "1", "b" -> "2")

      SbtWeb.withActorRefFactory(state, "Ng") {
        arf =>
          val svc = arf.actorOf(Services.actor())
          login(svc, state)
          val req = ServiceGet(map)
          println(s">>>" + req)
          val ServiceReply(res) = Await.result(svc ? req, 10.second).asInstanceOf[ServiceReply]
          println(s"${res}")
      }
    }
    state
  }

  def doDeploy(spool: File, hub: ActorRef, map: Map[String,String], args: Seq[String]) {
    val deployObjects = Spooler.load(readFile(spool))

    def filterAllSubstring(args: Seq[String], s: String) = args.map(s.indexOf(_) != -1).fold(true)(_ && _)

    val objs = deployObjects.deployObjects.filter(x => filterAllSubstring(args, x.toString))

    for (obj <- objs) {
      //log.debug(obj.toString)
      hub ! SpoonData(obj)
    }
    hub ! SpoonEnd("")
    println(s"Deployed #${objs.size}")

  }

  def deployCmd = Command.args("ndeploy", "<args>") { (state, args) =>

    val result: Option[(State, Result[File])] = Project.runTask(ngSpoon, state)
    result match {
      case Some((newState, Value(spool))) =>
        println(spool)
        SbtWeb.withActorRefFactory(state, "Ng") {
          arf =>
            val svc = arf.actorOf(Services.actor())
            val coll = arf.actorOf(Collector.actor(svc))
            val (url, focus, user, password) = login(svc, state)
            val result: Option[(State, Result[Map[String, String]])] = Project.runTask(ngUid, state)
            result match {
              case Some((newState, Value(map))) =>
                coll ! SpoonBegin(url, focus, user, password, map)
                doDeploy(spool, coll, map, args)
              case _ => println("cannot get uid map")
            }
        }
        newState
      case _ =>
        println("ERROR in ngSpoon")
        state
    }
  }

  val actorCommands = Seq(commands ++= Seq(serviceCmd, deployCmd))

}