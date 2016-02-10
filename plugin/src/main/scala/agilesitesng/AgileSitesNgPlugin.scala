package agilesitesng

import agilesites.AgileSitesPlugin
import agilesitesng.deploy.NgDeployPlugin
import agilesitesng.proxy.NgProxyPlugin
import agilesitesng.setup.NgSetupPlugin
import agilesitesng.wem.NgWemPlugin

import sbt._

object AgileSitesNgPlugin
  extends AutoPlugin {

  override def requires = AgileSitesPlugin &&
    NgProxyPlugin &&
    NgSetupPlugin &&
    NgDeployPlugin &&
   NgWemPlugin
}