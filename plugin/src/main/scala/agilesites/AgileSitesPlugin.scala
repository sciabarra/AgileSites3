package agilesites

import sbt._, Keys._
import agilesites.config.AgileSitesConfigPlugin
import agilesites.deploy.AgileSitesDeployPlugin
import agilesites.setup.AgileSitesSetupPlugin

import sbt.plugins.JvmPlugin

object AgileSitesPlugin
  extends AutoPlugin
  with Utils {

  override def requires = JvmPlugin &&
    AgileSitesConfigPlugin &&
    AgileSitesDeployPlugin &&
    AgileSitesSetupPlugin

}