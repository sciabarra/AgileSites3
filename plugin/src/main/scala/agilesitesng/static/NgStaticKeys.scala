package agilesitesng.static

import java.io.File

import sbt._

/**
 * Created by msciab on 02/07/15.
 */
object NgStaticKeys {
  lazy val staticExtensions = settingKey[Seq[String]]("statics extensions to import")
  lazy val staticAssetDir = settingKey[File]("static base asset dir")
  lazy val staticFiles = taskKey[Seq[String]]("locate statics")
  lazy val staticImport = taskKey[Unit]("import statics")
}
