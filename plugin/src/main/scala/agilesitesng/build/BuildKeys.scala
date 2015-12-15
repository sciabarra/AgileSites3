package agilesitesng.build

import sbt._, Keys._

/**
 * Created by msciab on 03/07/15.
 */
object BuildKeys {
  lazy val dockerConfig = settingKey[Seq[String]]("Docker Property File")
  lazy val dockerConfigMap = settingKey[Map[String, String]]("Docker Config  Map")
  lazy val dockerBase = settingKey[File]("Docker Config  Map")

}
