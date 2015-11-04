package agilesitesng.setup

import agilesites.Utils
import sbt._
import Keys._

/**
 * Created by msciab on 04/11/15.
 */
trait SetupSettings extends Utils {
  this: AutoPlugin =>

  import NgSetupKeys._

  lazy val ngSetupTask = ngSetup := {
    println("doing the setup..., #3")
  }

  val setupSettings = Seq(ngSetupTask)
}
