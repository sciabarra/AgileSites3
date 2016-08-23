package agilesites.deploy

import dispatch._
import dispatch.Defaults._
import java.net.URLDecoder
import com.ning.http.client.StringPart
import com.ning.http.multipart.FilePart
import java.net.URL
import java.io.File
import java.net.URLDecoder

import com.ning.http.client.StringPart
import com.ning.http.multipart.FilePart
import sbt._
import dispatch._
import dispatch.Defaults._


import agilesites.Utils
import sbt.Keys._
import sbt._

trait DeploySettings extends Utils {
  this: AutoPlugin =>

  import agilesites.config.AgileSitesConfigKeys._
  import agilesites.setup.AgileSitesSetupKeys._
  import agilesites.deploy.AgileSitesDeployKeys._

  /**
    * Extract the index of the classes annotated with the @Index annotation
    */
  def extractClassAndIndex(file: File): Option[Tuple2[String, String]] = {
    import scala.io._

    //println("***" + file)

    var packageRes: Option[String] = None;
    var indexRes: Option[String] = None;
    var classRes: Option[String] = None;
    val packageRe = """.*package\s+([\w\.]+)\s*;.*""".r;
    val indexRe = """.*@Index\(\"(.*?)\"\).*""".r;
    val classRe = """.*class\s+(\w+).*""".r;

    if (file.getName.endsWith(".java") || file.getName.endsWith(".scala"))
      for (line <- Source.fromFile(file).getLines) {
        line match {
          case packageRe(m) =>
            //println(line + ":" + m)
            packageRes = Some(m)
          case indexRe(m) =>
            //println(line + ":" + m)
            indexRes = Some(m)
          case classRe(m) =>
            //println(line + ":" + m)
            classRes = Some(m)
          case _ => ()
        }
      }

    if (packageRes.isEmpty || indexRes.isEmpty || classRes.isEmpty)
      None
    else {
      val t = (indexRes.get, packageRes.get + "." + classRes.get)
      Some(t)
    }
  }

  def uploadJar(uri: URL, jar: File, log: Logger, sites: String, username: String, password: String) = {
    val path = URLDecoder.decode(uri.getPath, "UTF-8").substring(1)
    val base = host(uri.getHost, uri.getPort)
    val req = base / path / "Satellite" <<? Map("pagename" -> "AAAgileDeploy")
    import scala.collection.JavaConverters._

    // hello, requesting the cookie
    val reqHello = req <<? Map("op" -> "hello")
    log.debug(reqHello.toRequest.getRawUrl)

    val cookies = Http(reqHello).apply.getCookies.asScala
    log.debug(s"hello ${cookies} ")

    // key, requesting the key
    val reqKey = cookies.foldLeft(req)(_.addCookie(_)) <<? Map("op" -> "key")
    log.debug(reqKey.toRequest.getRawUrl)
    val key = Http(reqKey).apply.getResponseBody.trim
    log.debug(s"key ${key} ")

    // upload the jar
    val reqFile = req.setMethod("POST").
      setHeader("Content-Type", "multipart/form-data").
      addBodyPart(new FilePart("jar", jar)).
      addBodyPart(new StringPart("op", "upload")).
      addBodyPart(new StringPart("_authkey_", key)).
      addBodyPart(new StringPart("username", username)).
      addBodyPart(new StringPart("password", password)).
      addBodyPart(new StringPart("sites", sites))

    val reqFile1 = cookies.foldLeft(reqFile)(_.addCookie(_))
    val resFile = Http(reqFile1).apply.getResponseBody.trim
    log.info(s"${resFile}")
    resFile
  }

  def upload(target: Option[String], log: Logger, jar: File, focus: String, sitesUser: String, sitesPass: String, sitesShared: String) = {
    target match {
      case Some(url) =>
        val targetUri = new java.net.URI(url)
        val proto = targetUri.getScheme
        val info: String = targetUri.getUserInfo
        val host = targetUri.getHost
        val path = targetUri.getPath
        /*
        val (user: String, pass: String) = if (info == null) {
          sitesUser -> sitesPassword
        } else {
          val a = info.split(":")
          if (a.length == 1)
            a(0) -> sitesPassword
          else
            a(0) -> a(1)
        }*/
        val user = sitesUser
        val pass = sitesPass

        proto match {
          case "file" =>
            val f = file(targetUri.getPath)
            f.getParentFile.mkdirs()
            IO.copyFile(jar, f)
            log.info("+++ " + f)
          case "scp" =>
            val port = if (targetUri.getPort == -1) 22 else targetUri.getPort
            if (!ScpTo.scp(jar.getAbsolutePath(), user, pass, host, port, path))
              log.error("!!! cannot upload ")
            else
              log.info("+++ uploaded " + url)
          case "http" =>
            uploadJar(new URL(url), jar, log, focus, user, pass)
          case _ =>
        }
      case None =>
        val destDir = file(sitesShared) / "agilesites"
        val destJar = file(sitesShared) / "agilesites" / jar.getName
        destDir.mkdir
        IO.copyFile(jar, destJar)
        log.info("+++ " + destJar.getAbsolutePath)
    }
  }

  // package jar task - build the jar and copy it  to destination
  val asPackageTask = asPackage := {
    val jar = (Keys.`package` in Compile).value
    val log = streams.value.log
    val focus = sitesFocus.value
    val url = sitesUrl.value
    if (sitesHello.value.isEmpty)
      log.error(s"Sites must be up and running as ${url}.")
    else {
      upload(asPackageTarget.value, log, jar, sitesFocus.value, sitesUser.value, sitesPassword.value, sitesShared.value)
    }
  }

  val asPackageDeployTask = asPackageDeploy := {
    val log = streams.value.log
    val url = sitesUrl.value
    asPackage.value
    log.info(httpCall("Deploy", "&sites=%s".format(sitesFocus.value), url, sitesUser.value, sitesPassword.value))
  }



  // generate index classes from sources
  val generateIndexTask = Def.task {
    val analysis = (compile in Compile).value
    val dstDir = (resourceManaged in Compile).value
    val s = streams.value

    val groupIndexed =
      analysis.apis.allInternalSources. // all the sources
        map(extractClassAndIndex(_)). // list of Some(index, class) or Nome
        flatMap(x => x). // remove None
        groupBy(_._1). // group by (index, (index, List(class))
        map { x => (x._1, x._2 map (_._2)) }; // lift to (index, List(class))

    //println(groupIndexed)

    val l = for ((subfile, lines) <- groupIndexed) yield {
      val file = dstDir / subfile
      val body = lines mkString("# generated - do not edit\n", "\n", "\n# by AgileSites build\n")
      writeFile(file, body, s.log)
      file
    }
    l.toSeq
  }

  val asDeployCmd = Command.command("asDeploy") { state =>
    state.copy(remainingCommands =
      Seq("asCopyStatics", "asDeployOnly", "asPopulate") ++ state.remainingCommands)
  }

  val deploySettings = Seq(asPackageTask
    , asPackageDeployTask
    , asPackageTarget := Some(sitesUrl.value)
    , asPopulate := cmov.toTask(" import_all @src/main/populate").value
    , commands ++= Seq(asDeployCmd)
    , resourceGenerators in Compile += generateIndexTask.taskValue
  )
}