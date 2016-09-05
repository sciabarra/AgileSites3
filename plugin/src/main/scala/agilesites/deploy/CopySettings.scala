package agilesites.deploy

import agilesites.Utils
import sbt.Keys._
import sbt._

trait CopySettings extends Utils {
  this: AutoPlugin =>

  import agilesites.config.AgileSitesConfigKeys._
  import agilesites.deploy.AgileSitesDeployKeys._

  val asScpTask = asScp := {

    val log = streams.value.log
    val fromTo = asScpFromTo.value

    if (fromTo.nonEmpty) {

      val targetUri = fromTo.get._2.toURI
      val srcFile = fromTo.get._1
      val proto = targetUri.getScheme

      if (proto == "file") {
        val f = file(targetUri.getPath)
        f.getParentFile.mkdirs()
        IO.copyFile(srcFile, f)
        log.info("+++ " + f)
      } else if (proto == "scp") {
        val Array(user, pass) = targetUri.getUserInfo.split(":")
        val host = targetUri.getHost
        val path = targetUri.getPath
        val port = if (targetUri.getPort == -1) 22 else targetUri.getPort
        if (!ScpTo.scp(srcFile.getAbsolutePath(), user, pass, host, port, path))
          log.error("!!! cannot upload ")
        else
          log.info("+++ uploaded " + targetUri)
      } else {
        log.error("unknown protocol for asUploadTarget")
      }
    }
  }

  val asCopyStaticsTask = asCopyStatics := {
    val base = baseDirectory.value
    val log = streams.value.log
    // copy  statics in resources
    /* off - copied from resources
    val dstDir = (resourceDirectory in Compile).value
    val srcDir = base / "src" / "main" / "static"
    log.debug("copyHtml from" + srcDir)
    recursiveCopy(srcDir, dstDir, log)(isHtml)
    */

    // copy resources in webapps
    val tgt = sitesWebapp.value
    val src = base / "src" / "main" / "resources"
    log.debug(" from" + src)
    val l = recursiveCopy(src, file(tgt), log)(x => true)
    println("*** copied " + (l.size) + " static files")
  }


  val copySettings = Seq(
    asCopyStaticsTask,
    asScpTask,
    asScpFromTo := None
  )
}