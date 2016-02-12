/**
  * Created by msciab on 26/06/15.
  */
package agilesitesng.static

import agilesites.config.AgileSitesConfigKeys
import agilesites.{AgileSitesConstants, Utils}
import sbt.Keys._
import sbt._

object NgStaticPlugin
  extends AutoPlugin
  with StaticSettings
  with Utils {

  import AgileSitesConfigKeys._
  import NgStaticKeys._

  val autoImport = NgStaticKeys

  override val projectSettings = Seq(
    staticAssetDir := baseDirectory.value / "src" / "main" / "assets"
    , staticExtensions := Seq("gif", "jpg", "js", "css")
    , staticFilesTask
    , staticImportTask)

}

