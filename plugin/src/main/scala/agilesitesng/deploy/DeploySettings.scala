package agilesitesng.deploy

import agilesites.config.AgileSitesConfigKeys._
import agilesites.Utils
import agilesitesng.deploy.actor.DeployProtocol._
import agilesitesng.deploy.model.Spooler
import akka.pattern.ask
import akka.util.Timeout
import sbt.{AutoPlugin, _}
import scala.concurrent.Await
import scala.concurrent.duration._
import sbt._, Keys._

/**
 * Created by msciab on 04/08/15.
 */
trait DeploySettings {
  this: AutoPlugin with Utils =>

  import NgDeployKeys._

  implicit val timeout = Timeout(10.seconds)

  val uidTask = uid in ng := {
    val prpFile = baseDirectory.value / "src" / "main" / "resources" / sitesFocus.value / "uid.properties"
    val prp = new java.util.Properties
    prp.load(new java.io.FileReader(prpFile))
    import scala.collection.JavaConverters._
    prp.asScala.toMap
  }

  val deployTask = deploy in ng := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val log = streams.value.log

    /*
    val hub = ngDeployHub.value
    val spool = (spoon in ng).toTask("").value

    // sending objects
    val deployObjects = Spooler.load(readFile(spool))

    def filterAllSubstring(args: Seq[String], s: String) = args.map(s.indexOf(_) != -1).fold(true)(_ && _)

    val objs = deployObjects.deployObjects.filter(x => filterAllSubstring(args, x.toString))

    val map = (uid in ng).value
    hub ! SpoonBegin(
      new java.net.URL(sitesUrl.value),
      sitesFocus.value, sitesUser.value,
      sitesPassword.value, map)
    for (obj <- objs) {
      log.debug(obj.toString)
      hub ! SpoonData(obj)
    }
    hub ! SpoonEnd("")
    println(s"Deployed #${objs.size}")
    */
  }

  val ngServiceTask = ngService := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    if (args.size == 0) {
      println("usage: ng:service <op> <key=value>")
      "no args"
    } else {
      // build url
      val opts = args.tail.map(s => if (s.indexOf("=") == -1) "value=" + s else s).mkString("&", "&", "")
      val req = s"${sitesUrl.value}/ContentServer?pagename=AAAgileService&op=${args.head}&username=${sitesUser.value}&password=${sitesPassword.value}${opts}"
      // send request
      println(">>> " + req)
      val r = httpCallRaw(req)
      println(r)
      r
    }
  }

  val serviceTask = service in ng := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    if (args.size == 0) {
      println("usage: ng:service <op> <key=value>")
      "no args"
    } else {
      val hub = ngDeployHub.value

      // input hello 0 a=1 b=2
      val opts = args.tail.map(s => if (s.indexOf("=") == -1) "value=" + s else s)
      // output List("value=0", "a=1", "b=2")
      val map = opts.map(_.split("=")).map(x => x(0) -> x(1)).toMap
      // output Map("value"->"0" "a" -> "1", "b" -> "2")


      var req = ServiceGet(map)
      println(">>> " + req)
      val ServiceReply(res) = Await.result(hub ? req, 10.second).asInstanceOf[ServiceReply]
      println("<<< ${res}")
      res
    }
  }

  def deploySettings = Seq(deployTask, uidTask, serviceTask, ngServiceTask)
}
