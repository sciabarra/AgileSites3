package agilesitesng.setup

import agilesites.config.{AgileSitesConfigKeys, AgileSitesConfigPlugin}
import agilesites.Utils
import sbt._, Keys._

/**
 * Created by msciab on 04/08/15.
 */
object NgSetupPlugin
  extends AutoPlugin
  with TagSettings
  with SetupSettings
  with UpgradeSettings {

  val autoImport = NgSetupKeys

  override def requires = AgileSitesConfigPlugin


  override val projectSettings = setupSettings ++
    upgradeSettings ++
    tagSettings

}
