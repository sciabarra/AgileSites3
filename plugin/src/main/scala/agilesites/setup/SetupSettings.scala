package agilesites.setup

import java.io._

import agilesites.Utils
import sbt.Keys._
import sbt._

/**
  * Created by msciab on 01/03/15.
  */
trait SetupSettings extends Utils {
  this: AutoPlugin
    with InstallerSettings
    with ToolsSettings
    with TomcatSettings =>

  import agilesites.config.AgileSitesConfigKeys._
  import agilesites.setup.AgileSitesSetupKeys._

  lazy val asSetupServletRequest = taskKey[Unit]("setup servlet request")
  lazy val asSetupServletRequestTask = asSetupServletRequest := {

    val webapp = sitesWebapp.value

    val prpFile = file(webapp) / "WEB-INF" / "classes" / "ServletRequest.properties"
    val prp = new java.util.Properties
    prp.load(new FileReader(prpFile))

    // shift the url assembler to add agilesites as the first
    if (prp.getProperty("uri.assembler.1.shortform") != "agilesites") {

      val p1s = prp.getProperty("uri.assembler.1.shortform")
      val p1c = prp.getProperty("uri.assembler.1.classname")
      val p2s = prp.getProperty("uri.assembler.2.shortform")
      val p2c = prp.getProperty("uri.assembler.2.classname")
      val p3s = prp.getProperty("uri.assembler.3.shortform")
      val p3c = prp.getProperty("uri.assembler.3.classname")
      val p4s = prp.getProperty("uri.assembler.4.shortform")
      val p4c = prp.getProperty("uri.assembler.4.classname")

      if (p4s != null && p4s != "") prp.setProperty("uri.assembler.5.shortform", p4s)
      if (p4c != null && p4c != "") prp.setProperty("uri.assembler.5.classname", p4c)
      if (p3s != null && p4s != "") prp.setProperty("uri.assembler.4.shortform", p3s)
      if (p3s != null && p4s != "") prp.setProperty("uri.assembler.4.classname", p3c)

      prp.setProperty("uri.assembler.3.shortform", p2s)
      prp.setProperty("uri.assembler.3.classname", p2c)
      prp.setProperty("uri.assembler.2.shortform", p1s)
      prp.setProperty("uri.assembler.2.classname", p1c)
      prp.setProperty("uri.assembler.1.shortform", "agilesites")
      prp.setProperty("uri.assembler.1.classname", "wcs.core.Assembler")
    }

    for (s <- sitesFocus.value.split(",")) {
      val nsite = normalizeSiteName(s)
      prp.setProperty("agilesites.site." + nsite, "/cs/Satellite/" + nsite)
      prp.setProperty("agilesites.name." + nsite, s)
    }
    prp.setProperty("agilesites.statics", sitesStatics.value)

    // store
    println("~ " + prpFile)
    prp.store(new FileWriter(prpFile),
      "updated by AgileSites setup")
  }

  // configure futurentense.ini
  lazy val asSetupFutureTenseIni = taskKey[Unit]("setup futuretense.ini")
  lazy val asSetupFutureTenseIniTask = asSetupFutureTenseIni := {

    val home = sitesHome.value
    val shared = sitesShared.value
    val version = sitesVersion.value
    val envision = sitesEnvision.value

    val prpFile = file(home) / "futuretense.ini"
    val prp = new java.util.Properties
    prp.load(new FileReader(prpFile))

    val jardir = file(shared) / "agilesites"

    prp.setProperty("agilesites.dir",
      jardir.getAbsolutePath);
    prp.setProperty("agilesites.poll",
      "1000");
    prp.setProperty("cs.csdtfolder",
      file(envision).getParentFile.getAbsolutePath())

    println("~ " + prpFile)
    prp.store(new FileWriter(prpFile),
      "updated by AgileSites setup")
  }

  // select jars for the setup offline
  lazy val asSetupCopyJarsWeb = taskKey[Unit]("setup servlet request")
  lazy val asSetupCopyJarsWebTask = asSetupCopyJarsWeb := {
    val webapp = sitesWebapp.value
    val version = sitesVersion.value
    val destLib = file(webapp) / "WEB-INF" / "lib"
    val addJars = asCoreClasspath.value
    val removeJars = destLib.listFiles.filter(_.getName.startsWith("agilesites"))
    setupCopyJars("agilesites_", destLib, addJars, removeJars)
  }

  // select jars for the setup online
  lazy val asSetupCopyJarsLib = taskKey[Unit]("setup servlet request")
  lazy val asSetupCopyJarsLibTask = asSetupCopyJarsLib := {

    val shared = sitesShared.value
    val parentLib = file(shared) / "agilesites"
    val destLib = parentLib / "lib"
    destLib.mkdirs()

    // jars to include when performing a setup
    // excluding core jars
    val excludeJars = asCoreClasspath.value
    val addJars = asApiClasspath.value.filter {
      f => excludeJars.find(_ == f).isEmpty
    }

    //println(addJars)

    // jars to remove when performing a setup
    val removeJars = destLib.listFiles

    //println(removeJars)
    setupCopyJars("", destLib, addJars, removeJars)

    for (file <- destLib.listFiles) {
      val parentFile = parentLib / file.getName
      if (parentFile.exists) {
        parentFile.delete
        println("- " + parentFile.getAbsolutePath)
      }
    }
  }

  // copy jars filtering and and remove
  def setupCopyJars(prefix: String, destLib: File, addJars: Seq[File], removeJars: Seq[File]) {

    // remove jars
    println("** removing old version of files **");
    for (file <- removeJars) {
      val tgt = destLib / file.getName
      tgt.delete
      println("- " + tgt.getAbsolutePath)
    }

    // add jars
    println("** installing new version of files **");
    for (file <- addJars) yield {
      val tgt = destLib / (prefix + file.getName)
      IO.copyFile(file, tgt)
      //println(file)
      println("+ " + tgt.getAbsolutePath)
    }
  }

  val asSetupOfflineTask = asSetupOffline := {

    //if (sitesHello.value.nonEmpty)
    //  throw new Exception("Web Center Sites must be offline.")

    println("*** Installing AgileSites for WebCenter Sites ***");

    // configuring
    asSetupServletRequest.value
    asSetupFutureTenseIni.value

    // installing jars
    asSetupCopyJarsWeb.value
    asSetupCopyJarsLib.value
    println(
      """**** Setup Complete.
        |**** Please restart your application server.
        |**** You need to complete installation with "asDeploy".""".stripMargin)
  }

  val asSetupOnlineCmd = Command.command("asSetupOnline") { state =>
    state.copy(remainingCommands =
      Seq("cmov setup", "service version reload=1") ++ state.remainingCommands)
  }

  val asSetupCmd = Command.command("asSetup") { state =>
    val extracted: Extracted = Project.extract(state)
    val base = (baseDirectory in extracted.currentRef get extracted.structure.data).get
    val prp = base / "agilesites.properties"
    if(!prp.exists) {
      println("Please, generate your site with asNewSite before installing agileSites")
      state
    } else {
      state.copy(remainingCommands =
        Seq("serverStop", "asSetupOffline", "serverStart", "asSetupOnline", "asDeploy") ++ state.remainingCommands)
    }
  }

  val asSetupWeblogicCmd = Command.command("asSetupWeblogic") { state =>
    state.copy(remainingCommands =
      Seq("asSetupOffline", "weblogicRedeployCs", "asSetupOnline", "asSetupOnline") ++ state.remainingCommands)
  }

  val setupSettings = Seq(
    ivyConfigurations ++= Seq(config("core"), config("api"), config("populate"))
    //, libraryDependencies ++= agilesitesDependencies
    , asCoreClasspath <<= (update) map {
      report => report.select(configurationFilter("core"))
    }, asApiClasspath <<= (update) map {
      report => report.select(configurationFilter("api"))
    }, asPopulateClasspath <<= (update) map {
      report => report.select(configurationFilter("populate"))
    }
    , asSetupOfflineTask
    , asSetupServletRequestTask
    , asSetupFutureTenseIniTask
    , asSetupCopyJarsWebTask
    , asSetupCopyJarsLibTask
    , commands ++= Seq(asSetupWeblogicCmd, asSetupCmd, asSetupOnlineCmd))

}
