package agilesitesng

import agilesites.AgileSitesPlugin
import agilesitesng.content.NgContentPlugin
import agilesitesng.deploy.NgDeployPlugin
import agilesitesng.proxy.NgProxyPlugin
import agilesitesng.setup.NgSetupPlugin
import agilesitesng.static.NgStaticPlugin
import agilesitesng.wem.NgWemPlugin

import sbt._

object AgileSitesNgPlugin
  extends AutoPlugin {

  override def requires = AgileSitesPlugin &&
    NgProxyPlugin &&
    NgSetupPlugin &&
    NgDeployPlugin &&
    NgWemPlugin &&
    NgStaticPlugin &&
    NgContentPlugin
}