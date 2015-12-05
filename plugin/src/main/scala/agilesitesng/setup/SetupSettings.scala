package agilesitesng.setup


import sbt._
import Keys._
import agilesites.Utils
import java.util.{Scanner, Properties}

/**
 * Created by msciab on 04/11/15.
 */
trait SetupSettings
  extends Utils
  with NgSetupSupport {
  this: AutoPlugin =>

  import NgSetupKeys._
  import agilesites.config.AgileSitesConfigKeys._

  lazy val setupOnlyTask = setupOnly := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val args1 = if (args.isEmpty) Seq(setupOnlyDefault.value) else args
    for (filename <- args1) {
      val file = new java.io.File(filename)
      if (file.exists)
        doSetupOnly(new java.net.URL(sitesUrl.value), sitesUser.value, sitesPassword.value,
          "AdminSite", file, streams.value.log)
      else
        println(s"${file} does not exist")
    }
  }

  lazy val setupTask = setup := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val log = streams.value.log

    try {
      val scanner = new Scanner(System.in);
      val prp = new Properties
      val file = new java.io.File("agilesites.properties")
      if (file.exists())
        prp.load(new java.io.FileReader(file))

      val url = new java.net.URL(if (args.length > 0)
        args(0)
      else if (prp.getProperty("sites.url") == null) {
        println("Sites URL: ")
        scanner.next()
      } else prp.getProperty("sites.url"))

      val user = if (args.length > 1)
        args(1)
      else if (prp.getProperty("sites.user") == null) {
        println("Sites User:")
        scanner.next()
      } else prp.getProperty("sites.user")

      val pass = if (args.length > 2)
        args(2)
      else if (prp.getProperty("sites.pass") == null) {
        println("Sites Password:")
        scanner.next()
      } else prp.getProperty("sites.pass")

      prp.setProperty("sites.url", url.toString)
      prp.setProperty("sites.user", user)
      prp.setProperty("sites.pass", pass)
      prp.setProperty("sites.port", url.getPort.toString)

      val err = doSetup(url, user, pass, streams.value.log)
      if (err.isEmpty) {
        val fw = new java.io.FileWriter("agilesites.properties")
        prp.store(fw, "Created by AgileSites")
        fw.close
        log.info("Created agilesites.properties")
        None
      } else err

    } catch {
      case ex: Throwable =>
        log.error(ex.getMessage)
        Some(ex.getMessage)
    }
  }

  val setupSettings = Seq(setupTask, setupOnlyTask,
    setupOnlyDefault := "plugin/src/main/resources/aaagile/ElementCatalog/AAAgileServices.txt")
}
