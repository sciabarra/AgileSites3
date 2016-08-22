package agilesites.deploy

import sbt._

/**
 * Created by msciab on 04/07/15.
 */
object AgileSitesDeployKeys {
  val asPackage = taskKey[Unit]("AgileSites package jar")
  val asPackageTarget = settingKey[Option[String]]("AgileSites package target")
  val asCopyStatics = taskKey[Unit]("AgileSites copy statics")
  val asDeployOnly = taskKey[Unit]("AgileSites deploy")
  val asPopulate = taskKey[Unit]("AgileSites populate")
  val asScpFromTo = settingKey[Option[(File, URL)]]("AgileSites scp from source file to target url (either scp:// or file://)")
  val asScp = taskKey[Unit]("AgileSites scp")
}
