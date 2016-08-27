package agilesites.deploy

import sbt._
import agilesites.config.AgileSitesConfigPlugin

object AgileSitesDeployPlugin
  extends AutoPlugin
    with DeploySettings
    with CopySettings
    with NewSiteSettings {

  override def requires = AgileSitesConfigPlugin

  val autoImport = AgileSitesDeployKeys

  override lazy val projectSettings =
    deploySettings ++
      copySettings ++
      newSiteSettings

}
