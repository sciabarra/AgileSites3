package agilesitesng

import agilesitesng.wem.WemFrontend
import com.typesafe.config.ConfigFactory
import com.typesafe.scalalogging.slf4j.LazyLogging
import net.liftweb.json._
import agilesitesng.wem.actor.Protocol._
import agilesitesng.wem.actor.{Protocol, Hub}
import akka.actor.ActorSystem
import java.io.File

/**
 * Created by msciab on 19/10/15.
 */
object AgileSitesNgSetup
  extends App
  with AgileSitesNgSetupSupport
  with LazyLogging {

  val config = ConfigFactory.load().getConfig("sbt-web")
  val url = new java.net.URL(config.getString("sites.url"))
  val user = config.getString("sites.user")
  val password = config.getString("sites.pass")
  val system = ActorSystem("sbt-web", config)

  val importFolder = new File("/Users/msciab/Dropbox/Work/MacBookPro/Sciabarra/AgileSites3/nglib/src/main/resources/aaagile/ElementCatalog")
  val libFolder = new File(new File(sys.props("user.dir")), "lib")
  libFolder.mkdirs

  val types = Seq("CSElement", "SiteEntry")

  val csElements = Seq("AAAgileInfo.jsp", "AAAgileService.jsp", "AAAgileApi.txt", "AAAgileServices.txt")
  val siteEntries = Seq("AAAgileInfo", "AAAgileService", "AAAgileApi", "AAAgileServices")

  //val csElements = Seq("AAAgileInfo.jsp")
  //val siteEntries = Seq("AAAgileInfo")
  val (tPrefix, nPrefix) = args.length match {
    case 0 => "" -> ""
    case 1 => "" -> args(0)
    case _ => args(0) -> args(1)
  }

  val wem = new WemFrontend(system, url, user, password)
  try {

    println(">> Enabling Types")
    types foreach {
      enableType(wem, "AdminSite", _)
    }

    println(">> Loading Asset Map")
    val map = loadAssetMap(wem, "AdminSite", importFolder)
    println(map)

    if ("CSElement".startsWith(tPrefix))
      csElements foreach { filename: String =>
        if (filename.startsWith(nPrefix)) {
          println(s">> Importing CSElement:${filename}")
          importCSElement(wem, map, "AdminSite",
            new File(importFolder, filename))
        }
      }

    if ("SiteEntry".startsWith(tPrefix))
      siteEntries foreach { filename: String =>
        if (filename.startsWith(nPrefix)) {
          println(s">> Importing SiteEntry:${filename}")
          importSiteEntry(wem, map, "AdminSite", filename)
        }
      }

    val version = map("Info:sites.version")
    val files = s"jars.${version}.txt";
    val lib = new File(libFolder, sys.props.getOrElse("profile", "") + version)
    downloadJars(wem, files, lib)

    /*templates foreach { filename: String =>
      importTemplate(wem, "AdminSite", new File(importFolder, filename))
    }*/

  } catch {
    case ex: Throwable =>
      ex.printStackTrace
      logger.error("crash!", ex)
  } finally {
    wem.quit
  }
}
