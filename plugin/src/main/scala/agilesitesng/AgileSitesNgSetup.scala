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

  val importFolder = new java.io.File("/Users/msciab/Dropbox/Work/MacBookPro/Sciabarra/AgileSites3/nglib/src/main/resources/aaagile/ElementCatalog")

  val types = Seq("CSElement", "SiteEntry")

  //val csElements = Seq("AAAgileInfo.jsp","AAAgileService.jsp",  "AAAgileApi.txt", "AAAgileServices.txt")
  //val siteEntries = Seq("AAAgileInfo", "AAAgileService")

  val csElements = Seq("AAAgileInfo.jsp")
  val siteEntries = Seq("AAAgileInfo")

  val wem = new WemFrontend(system, url, user, password)
  try {


    println(">> Enabing Types")

    types foreach {
      enableType(wem, "AdminSite", _)
    }

    println(">> Loading Asset Map")
    val map = loadAssetMap(wem, "AdminSite", importFolder)

    println(map)

    csElements foreach { filename: String =>
      println(s">> Importing CSElement:${filename}")
      importCSElement(wem, map, "AdminSite",
        new File(importFolder, filename))
    }

    siteEntries foreach { filename: String =>
      println(s">> Importing SiteEntry:${filename}")
      importSiteEntry(wem, map, "AdminSite", filename)
    }

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
