package agilesitesng.setup

import java.util.{Scanner, Properties}

import agilesites.Utils
import sbt._
import Keys._

/**
 * Created by msciab on 04/11/15.
 */
trait SetupSettings
  extends Utils
  with NgSetupSupport {
  this: AutoPlugin =>

  import NgSetupKeys._

  lazy val setupTask = setup in ng := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val log = streams.value.log
    val scanner = new Scanner(System.in);
    val err = try {

      val prp = new Properties
      val file = new java.io.File("agilesites.properties")
      if (file.exists())
        prp.load(new java.io.FileReader(file))

      val url = new java.net.URL(if (args.length > 0)
        args(0)
      else if(prp.getProperty("sites.url")==null) {
        println("Sites URL: ")
        scanner.next()
      } else prp.getProperty("sites.url"))

      val user = if (args.length > 1)
        args(1)
      else if(prp.getProperty("sites.user")==null) {
        println("Sites User:")
        scanner.next()
      } else prp.getProperty("sites.user")

      val pass = if (args.length > 2)
        args(2)
      else if(prp.getProperty("sites.pass")==null) {
        println("Sites Password:")
        scanner.next()
      } else prp.getProperty("sites.pass")

      prp.setProperty("sites.url", url.toString)
      prp.setProperty("sites.user", user)
      prp.setProperty("sites.pass", pass)
      prp.setProperty("sites.port", url.getPort.toString)

      val err = doSetup(url, user, pass)
      if (err.isEmpty) {
        val fw = new java.io.FileWriter("agilesites.properties")
        prp.store(fw, "Created by AgileSites")
        fw.close
        log.info("Created agilesites.properties")
        None
      } else err

    } catch {
      case ex: Throwable => Some(ex.getMessage)
    }

    if (err.nonEmpty)
      log.error(err.get)
  }

  val setupSettings = Seq(setupTask)
}
