/**
  * Created by msciab on 26/06/15.
  */
package agilesitesng.proxy

import agilesites.setup.AgileSitesSetupKeys._
import sbt._, sbt.Keys._

import agilesites.{AgileSitesConstants, Utils}
import agilesites.config.{AgileSitesConfigKeys, AgileSitesConfigPlugin}
import scala.concurrent.duration._

object NgProxyPlugin
  extends AutoPlugin
  with Utils
  with ProxySettings {

  import AgileSitesConfigKeys._
  import NgProxyKeys._

  val autoImport = NgProxyKeys
  val akkahttp = config("akkahttp")

  override val projectSettings = Seq(
    ivyConfigurations += akkahttp
    , libraryDependencies ++= AgileSitesConstants.akkaHttpDependencies map {
      _ % "akkahttp"
    }
    , proxyRemoteUrl := new java.net.URL(sitesUrl.value)
    , proxyLocalDir := baseDirectory.value / "src" / "main" / "assets"
    , proxyPort := 3000
    , proxyTask
    , proxyTimeout := sitesTimeout.value
    , proxyClasspath <<= (update) map {
      report => report.select(configurationFilter("akkahttp"))
    }
  )

}

