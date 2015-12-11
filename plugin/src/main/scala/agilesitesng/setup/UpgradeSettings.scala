package agilesitesng.setup

import agilesites.Utils
import sbt.Keys._
import sbt._

import scala.io.Source

trait UpgradeSettings
  extends Utils {
  this: AutoPlugin =>

  def upgradeCmd = Command.args("upgrade", "<args>") { (state, args) =>
    val plugin = if (args.size > 0) {
      args(0)
    } else {
      val base = sys.props.getOrElse("agilesites.latest", "http://www.sciabarra.com/agilesites/")
      val url = if (base.startsWith("http://"))
        new java.net.URL(base)
      else new java.io.File(base).toURI.toURL
      Source.fromURL(url + "agilesites.ver").getLines.next
    }
    IO.write(file("project") / "agilesites.ver", plugin + "\n")
    println(s"upgrading to plugin: ${plugin}")
    state.copy(remainingCommands =
      Seq("reload") ++ state.remainingCommands)
  }

  val upgradeSettings = Seq(
    commands ++= Seq(upgradeCmd)
  )
}