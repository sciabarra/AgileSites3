package agilesites.config

import sbt.Keys._
import sbt._
import sbt.plugins.JvmPlugin

object AgileSitesConfigPlugin
  extends AutoPlugin
  with PropertySettings
  with VersionSettings {

  override def requires = JvmPlugin

  val autoImport = AgileSitesConfigKeys

  import AgileSitesConfigKeys._

  override val projectSettings = propertySettings ++ versionSettings ++ Seq(
    sitesUrl  := utilPropertyMap.value.getOrElse("sites.url",
      s"http://${sitesHost.value}:${sitesPort.value}/cs"),
    sitesUser  := utilPropertyMap.value.getOrElse("sites.user", "fwadmin"),
    sitesPassword  := utilPropertyMap.value.getOrElse("sites.password", "xceladmin"),
    sitesAdminUser := utilPropertyMap.value.getOrElse("sites.admin.user", "ContentServer"),
    sitesAdminPassword  := utilPropertyMap.value.getOrElse("sites.admin.password", "password"),

    // focus on which site?
    sitesFocus := utilPropertyMap.value.getOrElse("sites.focus", "Demo"),
    sitesStatics := utilPropertyMap.value.getOrElse("sites.statics", "js,css,gif,png,jpg,ico,woff,woff2,ttf"),
    sitesFocusId := uidPropertyMap.value.getOrElse(s"Site.${sitesFocus.value}.Config", "-1").toLong,

    // installation properties
    sitesDirectory := file(utilPropertyMap.value.getOrElse("sites.directory",
      (baseDirectory.value / "sites").getAbsolutePath)),
    sitesHome := utilPropertyMap.value.getOrElse("sites.home",
      (sitesDirectory.value / "home").getAbsolutePath),
    sitesShared := utilPropertyMap.value.getOrElse("sites.shared",
      (sitesDirectory.value / "shared").getAbsolutePath),
    sitesWebapp := utilPropertyMap.value.getOrElse("sites.webapp",
      (sitesDirectory.value / "webapps" / "cs").getAbsolutePath),
    sitesWebappName := utilPropertyMap.value.getOrElse("sites.webapp.name",
      (file(sitesWebapp.value).getName)),

    sitesTimeout := utilPropertyMap.value.getOrElse("sites.timeout", "60").toInt,
    sitesPopulate := utilPropertyMap.value.getOrElse("sites.populate",
      (file(sitesHome.value) / "export" / "populate").getAbsolutePath),
    sitesEnvision := utilPropertyMap.value.getOrElse("sites.envision",
      (file(sitesHome.value) / "export" / "envision").getAbsolutePath),

    // versions
    sitesVersion := utilPropertyMap.value.getOrElse("sites.version", "12.2.1.0.0"),
    sitesPort := utilPropertyMap.value.getOrElse("sites.port", "11800"),
    sitesHost := utilPropertyMap.value.getOrElse("sites.host", "localhost"),
    satelliteWebapp := utilPropertyMap.value.getOrElse("satellite.webapp",
      (file(sitesWebapp.value).getParentFile / "ss").getAbsolutePath),
    satelliteHome := utilPropertyMap.value.getOrElse("satellite.home", sitesHome.value),
    satelliteUser := utilPropertyMap.value.getOrElse("satellite.user", "SatelliteServer"),
    satellitePassword := utilPropertyMap.value.getOrElse("satellite.password", "password"),
    satelliteUrl := utilPropertyMap.value.getOrElse("satellite.url",
      s"http://${sitesHost.value}:${sitesPort.value}/ss"),

    weblogicUser := utilPropertyMap.value.getOrElse("weblogic.user", "weblogic"),
    weblogicPassword := utilPropertyMap.value.getOrElse("weblogic.password", "password"),
    weblogicUrl := utilPropertyMap.value.getOrElse("weblogic.url", "t3://localhost:7001"),
    weblogicServer := file(utilPropertyMap.value.getOrElse("weblogic.server", "wlserver")),
    weblogicTargets := utilPropertyMap.value.getOrElse("weblogic.targets", "AdminServer"),
    sitesHello := {
      helloSites(sitesUrl.value)
    })
}