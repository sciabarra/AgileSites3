package agilesitesng.build

import sbt._, Keys._

import sbt.plugins.JvmPlugin

object BuildPlugin
  extends AutoPlugin
with DockerSettings
  {

  override def requires = JvmPlugin

  val autoImport = BuildKeys

  //override def globalSettings: Seq[Setting[_]] = super.globalSettings ++ actorGlobalSettings

  override lazy val projectSettings = dockerSettings
}