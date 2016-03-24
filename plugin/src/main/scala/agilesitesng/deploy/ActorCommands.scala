package agilesitesng.deploy

import java.io.File
import java.nio.file.{Path, Files}

import sbt._
import Keys._
import akka.pattern.ask
import scala.concurrent.Await
import scala.concurrent.duration._
import agilesites.Utils
import agilesitesng.deploy.actor.DeployProtocol._
import agilesitesng.deploy.actor.{Collector, Services}
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

  def getTimeout(state: State): Int = {
    val extracted: Extracted = Project.extract(state)
    import extracted._
    val timeoutOpt = sitesTimeout in currentRef get structure.data
    timeoutOpt.getOrElse(30)
  }

  def timeoutCmd = Command.args("timeout", "<args>") { (state, args) =>
    println(getTimeout(state))
    state
  }

  def serviceCmd = Command.args("service", "<args>") { (state, args) =>

    val timeOut = getTimeout(state)

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
          val svc = arf.actorOf(Services.actor())
          login(svc, state)
          val req = ServiceGet(map)
          println(s">>>" + req)
          Await.result(svc ? req, timeOut.seconds).asInstanceOf[ServiceReply] match {
            case SimpleServiceReply(res) => println(s"${res}")
            case JsonFileServiceReply(path, filename, res) => writeToFile(path, filename, res)
          }
          //println(s"${res}")
      }
    }
    state
  }

  def writeToFile(path: String, filename: String, value: String): Unit = {
    val exportPath = new File(path)
    exportPath.mkdirs()
    val exportFile = new File(exportPath, filename)
    val pw = new java.io.PrintWriter(exportFile)
    try pw.write(value) finally pw.close()
  }

  def doDeploy(spool: File, hub: ActorRef, map: Map[String, String], args: Seq[String]) {
    val deployObjects = Spooler.load(readFile(spool))

    def filterAllSubstring(args: Seq[String], s: String) = args.map(s.indexOf(_) != -1).fold(true)(_ && _)

    val objs = deployObjects.deployObjects.filter(x => filterAllSubstring(args, x.toString))

    for (obj <- objs) {
      //println(obj.toString)
      //log.debug(obj.toString)
      hub ! SpoonData(obj)
    }
    hub ! SpoonEnd("")
    println(s"Deployed #${objs.size}")

  }

  def deployCmd = Command.args("deploy", "<args>") { (state, args) =>
    val result: Option[(State, Result[File])] = Project.runTask(ngSpoon, state)
    result match {
      case Some((newState, Value(spool))) =>
        println(spool)
        SbtWeb.withActorRefFactory(state, "Ng") {
          arf =>
            val svc = arf.actorOf(Services.actor())
            val coll = arf.actorOf(Collector.actor(svc, getTimeout(state)))
            val (url, focus, user, password) = login(svc, state)
            val result: Option[(State, Result[Map[String, String]])] = Project.runTask(ngUid, state)
            result match {
              case Some((newState, Value(map))) =>
                //println(">>> begin")
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

  def exportCmd = Command.args("exportContent", "<args>") { (state, args) =>
    val timeOut = getTimeout(state)

    if (args.size == 0) {
      println("usage: exportContent assetType <cid=value>")
    } else {
      // input hello 0 a=1 b=2
      val opts = args.map(s => if (s.indexOf("=") == -1) "type=" + s else s)
      // output List("value=0", "a=1", "b=2")

      val map = opts.map(_.split("=")).map(x => x(0) -> x(1)).toMap + ("op" -> "export") + ("exportPath" -> "export")
      // output Map("value"->"0" "a" -> "1", "b" -> "2")

      SbtWeb.withActorRefFactory(state, "Ng") {
        arf =>
          val svc = arf.actorOf(Services.actor())
          login(svc, state)
          val req = ServiceGet(map)
          println(s">>>" + req)
          Await.result(svc ? req, timeOut.seconds).asInstanceOf[ServiceReply] match {
            case SimpleServiceReply(res) => println(s"${res}")
            case JsonListServiceReply(idList) => doExport(svc, map.get("type").get, idList)
            case JsonFileServiceReply(path, filename, res) => writeToFile(path, filename, res)
          }
        //println(s"${res}")
      }
    }
    state
  }

  def doExport(svc: ActorRef, assetType:String, list: List[String]) {

    for (id <- list) {
      val map = Map("op" -> "export", "exportPath" -> "export", "type" -> assetType, "cid" -> id)
      val req = ServiceGet(map)
      println(s">>>" + req)
      Await.result(svc ? req, 30.seconds).asInstanceOf[ServiceReply] match {
        case SimpleServiceReply(res) => println(s"${res}")
        case JsonFileServiceReply(path, filename, res) => writeToFile(path, filename, res)
      }
    }

  }

  def doImport(svc: ActorRef, assetType:String, list: List[String], site:String) {

    for (fileName <- list) {
      val cid = fileName.take(1 + fileName.lastIndexOf("."))
      val assetJson = readTextFile(fileName)
      val map = Map("op" -> "import", "importPath" -> "import", "site" -> site, "type" -> assetType, "cid" -> cid, "assetJson" -> assetJson)
      val req = ServiceGet(map)
      println(s">>>" + req)
      Await.result(svc ? req, 30.seconds).asInstanceOf[ServiceReply] match {
        case SimpleServiceReply(res) => println(s"${res}")
        case JsonFileServiceReply(path, filename, res) => writeToFile(path, filename, res)
      }
    }

  }
  def importCmd = Command.args("importContent", "<args>") { (state, args) =>
    val timeOut = getTimeout(state)

    if (args.isEmpty) {
      println("usage: importContent <assetType> <cid>")
    } else if (args.size == 1) {
      println("usage: importContent <assetType> <cid>")
    } else {
      //val map = Map("op" -> "import", "importPath" -> "export", "cid" -> args(2))
      // output Map("value"->"0" "a" -> "1", "b" -> "2")
      val assetType = args(0)
      val cid = args(1)
      val filename = s"import/$assetType/$cid.json"
      val files = filename :: Nil
      SbtWeb.withActorRefFactory(state, "Ng") {
        arf =>
          val svc = arf.actorOf(Services.actor())
          val (url, focus, user, password) = login(svc, state)
          doImport(svc,assetType, files, focus)
      }
    }
    state
  }

  def readTextFile(filename: String): String = {
    val bufferedSource = scala.io.Source.fromFile(filename)
    val content = bufferedSource.getLines.mkString("")
    bufferedSource.close
    content
  }

  val actorCommands = Seq(commands ++= Seq(serviceCmd, deployCmd, timeoutCmd, exportCmd, importCmd))

}