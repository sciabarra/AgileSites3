package agilesitesng.deploy

import agilesites.config.AgileSitesConfigPlugin
import agilesites.Utils
import com.typesafe.sbt.web.SbtWeb
import sbt._, Keys._
import sbt.plugins.JvmPlugin

import scala.concurrent.duration._

object NgDeployPlugin
  extends AutoPlugin
  with SpoonSettings
  with SqlSettings
  with ActorCommands
  with Utils {

  override def requires = JvmPlugin && SbtWeb && AgileSitesConfigPlugin

  val autoImport = NgDeployKeys

  //override def globalSettings: Seq[Setting[_]] = super.globalSettings ++ actorGlobalSettings

  override lazy val projectSettings = actorCommands ++ spoonSettings ++ sqlSettings
}