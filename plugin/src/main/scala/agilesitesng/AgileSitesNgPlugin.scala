package agilesitesng

import agilesites.AgileSitesPlugin
import agilesites.config.AgileSitesConfigPlugin
import agilesitesng.deploy.NgDeployPlugin
import agilesitesng.setup.NgSetupPlugin

import sbt._

object AgileSitesNgPlugin
  extends AutoPlugin {

  override def requires = AgileSitesPlugin &&
    NgSetupPlugin &&
    NgDeployPlugin

}