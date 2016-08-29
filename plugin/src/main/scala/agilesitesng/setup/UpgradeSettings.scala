package agilesitesng.setup

import agilesites.Utils
import sbt.Keys._
import sbt._
import agilesites.AgileSitesConstants.is11g

import scala.io.Source

trait UpgradeSettings
  extends Utils {
  this: AutoPlugin =>

  def upgradeCmd = Command.args("asUpgrade", "<args>") { (state, args) =>
    val curVer = Source.fromFile(file("agilesites.ver")).getLines.next.trim
    val newVer = if (args.size > 0) {
      val ver = args(0).trim
      println(s"You requestested release: ${ver}")
      ver
    } else {
      val base = sys.props.getOrElse("agilesites.latest", s"https://s3.amazonaws.com/agilesites3-repo/releases/${if (is11g) "11g/" else "12c/"}")
      val url = new java.net.URL(base)
      val ver = Source.fromURL(url + "agilesites.ver").getLines.next.trim
      println(s"Latest release available: ${ver}")
      ver
    }
    if (curVer == newVer) {
      println(s"You are already to the release ${newVer}")
      state
    } else {
      IO.write(file("agilesites.ver"), newVer + "\n")
      println(s"*** upgrading to plugin: ${newVer}\n *** remember to reinstall with asSetup")
      state.copy(remainingCommands =
        Seq("reload") ++ state.remainingCommands)
    }
  }

  val upgradeSettings = Seq(
    commands ++= Seq(upgradeCmd)
  )
}