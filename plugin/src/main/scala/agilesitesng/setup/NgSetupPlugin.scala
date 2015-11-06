package agilesitesng.setup

import agilesites.config.{AgileSitesConfigKeys, AgileSitesConfigPlugin}
import agilesitesng.Utils
import sbt._, Keys._

/**
 * Created by msciab on 04/08/15.
 */
object NgSetupPlugin
  extends AutoPlugin
  with ConcatSettings
  with TagSettings
  with SetupSettings {

  val autoImport = NgSetupKeys

  override def requires = AgileSitesConfigPlugin

  //override def trigger = AllRequirements

  import AgileSitesConfigKeys._


  override val projectSettings =
    concatSettings ++
      tagSettings ++
      setupSettings

}
