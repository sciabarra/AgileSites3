package agilesitesng.deploy

import agilesitesng.deploy.model.SpoonModel.Controller
import sbt._
import Keys._
import akka.pattern.ask
import scala.concurrent.Await
import scala.concurrent.duration._
import agilesites.Utils
import agilesitesng.deploy.actor.DeployProtocol._
import agilesitesng.deploy.actor.{Notifier, Collector, Services}
import agilesitesng.deploy.model.Spooler
import akka.actor.ActorRef
import akka.util.Timeout
import com.typesafe.sbt.web.SbtWeb
import agilesitesng.deploy.NgDeployKeys._
import agilesites.config.AgileSitesConfigKeys._

/**
  * Created by msciab on 24/11/15.
  */
trait ActorCommands {
  this: AutoPlugin with Utils =>

  //implicit val myTimeout = Timeout(60.seconds)

  def login(svc: ActorRef, state: State): (URL, String, String, String) = {
    // login into services
    val extracted: Extracted = Project.extract(state)
    val url = new java.net.URL((sitesUrl in extracted.currentRef get extracted.structure.data).get)
    val user = (sitesUser in extracted.currentRef get extracted.structure.data).get
    val password = (sitesPassword in extracted.currentRef get extracted.structure.data).get
    val focus = (sitesFocus in extracted.currentRef get extracted.structure.data).get
    val timeout = getTimeout(state)
    implicit val myTimeout = Timeout(timeout.seconds)
    Await.result(svc ? ServiceLogin(url, user, password), timeout.second)
    (url, focus, user, password)
  }

  def getTimeout(state: State): Int = {
    val extracted: Extracted = Project.extract(state)
    import extracted._
    val timeoutOpt = sitesTimeout in currentRef get structure.data
    timeoutOpt.getOrElse(60)
  }

  def timeoutCmd = Command.args("timeout", "<args>") { (state, args) =>
    println(getTimeout(state))
    state
  }

  def serviceCmd = Command.args("service", "<args>") { (state, args) =>

    val timeOut = getTimeout(state)
    implicit val myTimeout = Timeout(timeOut.seconds)

    if (args.size == 0) {
      println("usage: service <op> <key=value>")
    } else {
      // input hello 0 a=1 b=2
      val opts = args.map(s => if (s.indexOf("=") == -1) "value=" + s else s)
      // output List("value=0", "a=1", "b=2")

      val map = opts.tail.map(_.split("=")).map(x => x(0) -> x(1)).toMap + ("op" -> args.head)
      // output Map("value"->"0" "a" -> "1", "b" -> "2")

      SbtWeb.withActorRefFactory(state, "Ng") {
        arf =>
          val notifier = arf.actorOf(Notifier.actor())
          val svc = arf.actorOf(Services.actor(notifier))
          login(svc, state)
          val req = ServiceGet(map)
          println(s">>>" + req)
          val ServiceReply(res) = Await.result(svc ? req, timeOut.seconds).asInstanceOf[ServiceReply]
          println(s"${res}")
      }
    }
    state
  }

  def doDeploy(spool: File, hub: ActorRef, map: Map[String, String], args: Seq[String], skipCtl: Boolean, listOnly: Boolean, verbose: Boolean) {

    println(s"verbose=${verbose} listOnly=${listOnly} args=${args.mkString(":")}")

    // list objects, skipping controllers if required
    val deployObjects =
      Spooler.load(readFile(spool)).deployObjects.filter(x =>
        if (skipCtl) !x.isInstanceOf[Controller] else true
      )

    def filterAllSubstring(args: Seq[String], s: String) =
      args.map(s.indexOf(_) != -1).fold(true)(_ && _)

    val objs = deployObjects.filter(x => filterAllSubstring(args, x.toString))

    if (listOnly) {
      println("*** Listing only - NO DEPLOY ***")
      for (obj <- objs) {
        println(obj.toString)
      }
    } else {
      for (obj <- objs) {
        if(verbose)
          println(obj.toString)
        hub ! SpoonData(obj)
      }
      hub ! SpoonEnd("")
      println(s"Deployed #${objs.size}")
    }
  }

  def deployCmd = Command.args("deploy", "<args>") { (state, args) =>

    if (args.nonEmpty && args(0) == "-h") {
      println("usage: deploy [-l|-v] [filter-substring]")
      state
    } else {
      val (listOnly, verbose, args1) =
        if (args.nonEmpty && args(0) == "-l")
          (true, false, args.tail)
        else if (args.nonEmpty && args(0) == "-v")
          (false, true, args.tail)
        else
          (false, false, args)

      val extracted: Extracted = Project.extract(state)
      val skipCtl = (ngSpoonSkipControllers in extracted.currentRef get extracted.structure.data).get
      val result: Option[(State, Result[File])] = Project.runTask(ngSpoon, state)
      result match {
        case Some((newState, Value(spool))) =>
          // prepare the actor
          SbtWeb.withActorRefFactory(state, "Ng") {
            arf =>
              val notifier = arf.actorOf(Notifier.actor())
              val svc = arf.actorOf(Services.actor(notifier))
              val coll = arf.actorOf(Collector.actor(svc, getTimeout(state)))
              val (url, focus, user, password) = login(svc, state)
              val result: Option[(State, Result[Map[String, String]])] = Project.runTask(ngUid, state)
              result match {
                case Some((newState, Value(map))) =>
                  //println(">>> begin")

                  if (!listOnly)
                    coll ! SpoonBegin(url, focus, user, password, map)

                  doDeploy(spool, coll, map, args1, skipCtl, listOnly, verbose)

                case _ => println("cannot get uid map")
              }
          }
          newState
        case _ =>
          println("ERROR in ngSpoon")
          state
      }
    }
  }

  val actorCommands = Seq(commands ++= Seq(serviceCmd, deployCmd, timeoutCmd))

}