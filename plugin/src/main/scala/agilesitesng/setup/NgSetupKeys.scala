package agilesitesng.setup

import sbt._

/**
 * Created by msciab on 02/07/15.
 */
object NgSetupKeys {

  val ng = config("ng")

  lazy val ngConcatJavaMap = settingKey[Map[File, PathFinder]]("map concatenation")

  lazy val ngTagWrapperGen = taskKey[Unit]("Generate Tag Wrappers")

  lazy val ngConcatJava = taskKey[String]("Concatenate Java source files")

  lazy val setup = inputKey[Option[String]]("Installing AgileSites")

  lazy val setupOnly = inputKey[Unit]("Incremental Installing AgileSites")

  lazy val setupOnlyDefault = settingKey[String]("Default setupOnlyFile")

}
