package agilesites.config

import java.util.Properties
import agilesites.Utils
import sbt.Keys._
import sbt._

import scala.io.Source

/**
 * Created by msciab on 08/02/15.
 */
trait PropertySettings extends Utils {
  this: AutoPlugin =>

  import AgileSitesConfigKeys._
  import scala.collection.JavaConverters._

  val profile = Option(System.getProperty("profile")).map(Seq(_)).getOrElse(Nil)

  val propertyFiles = Seq(
    "agilesites.dist.properties",
    "agilesites.properties",
    "agilesites.local.properties") ++
    profile.map(x =>
      s"agilesites.${x}.properties")

  lazy val utilPropertyMapTask = utilPropertyMap in ThisBuild := {
    try {
      val prp: Properties = new Properties
      val loaded = for {
        prpFileName <- utilProperties.value
        prpFile = baseDirectory.value / prpFileName
        if prpFile.exists
      } yield {
          prp.load(new java.io.FileInputStream(prpFile))
          prpFile
        }

      println("=== Property files:")
      loaded.foreach(println)
      println("--- Properties:")

      val map = prp.asScala.toMap
      for ((k, v) <- map)
        println(s"${k}=${v}")

      println("=== ")
      map
    } catch {
      case _: Throwable => Map()
    }
  }

  lazy val uidPropertyMapTask = uidPropertyMap in ThisBuild := {
    val prp: Properties = new Properties
    val prpFile = baseDirectory.value / "src" / "main" / "resources" / sitesFocus.value / "uid.properties"
    if (prpFile.exists) {
      System.out.println(">>> " + prpFile)
      prp.load(new java.io.FileInputStream(prpFile))
    }
    prp.asScala.toMap
  }

  // display a prompt with the project name
  lazy val utilShellPromptTask = shellPrompt in ThisBuild := {
    state =>
      Project.extract(state).currentRef.project +
        Option(System.getProperty("profile")).map("[" + _ + "]> ").getOrElse("> ")
  }

  def profileCmd = Command.args("profile", "<args>") { (state, args) =>
    if (args.size != 1) {
      println("usage: profile <profile>|- (- = noprofile)")
      state
    } else {
      val (profile, profileSetter) =
        if (args.head == "-")
          "" -> """System.getProperties.remove("profile")"""
        else
          args.head + "." -> s"""System.setProperty("profile", "${args.head}")"""
      val prp = state.configuration.baseDirectory / s"agilesites${profile}.properties"
      //if(!prp.exists())
      //  println(s"WARNING! no ${prp.getName} file found - are you using the right profile name?")
      state.copy(remainingCommands =
        Seq( s"""eval ${profileSetter} """, "reload") ++ state.remainingCommands)
    }
  }

  def upgradeCmd = Command.args("upgrade", "<args>") { (state, args) =>
    val (plugin, nglib) = if (args.size > 2) {
      args(0) -> args(1)
    } else if (args.size == 1) {
      args(0) -> args(0)
    } else {
      val base = sys.props.getOrElse("agilesites.latest", "http://www.sciabarra.com/agilesites/")
      val url = if (base.startsWith("http://"))
        new java.net.URL(base)
      else new java.io.File(base).toURI.toURL
      Source.fromURL(url + "plugin/version.txt").getLines.next ->
        Source.fromURL(url + "nglib/version.txt").getLines.next
    }
    IO.write(file("project") / "plugin.txt", plugin+"\n")
    IO.write(file("project") / "nglib.txt", nglib+"\n")
    println(s"upgrading to plugin: ${plugin} lib: ${nglib}")
    state.copy(remainingCommands =
      Seq("reload") ++ state.remainingCommands)
  }

  val propertySettings = Seq(
    utilProperties := propertyFiles,
    utilShellPromptTask,
    utilPropertyMapTask,
    uidPropertyMapTask,
    commands ++= Seq(profileCmd, upgradeCmd)
  )
}
