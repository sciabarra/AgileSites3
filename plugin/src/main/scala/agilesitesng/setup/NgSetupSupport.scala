package agilesitesng.setup

import java.io.File
import java.net.URL
import agilesites.Utils

import scala.io.Source
import akka.actor.ActorSystem
import agilesitesng.wem.WemFrontend
import agilesitesng.wem.actor.Protocol.{Delete, Get, Post, Put}
import agilesitesng.wem.model.{Encoding, WemCSElement, WemSiteEntry}
import com.typesafe.config.{Config, ConfigFactory}
import com.typesafe.scalalogging.slf4j.LazyLogging
import net.liftweb.json.JsonAST.{JArray, JField, JString}
import net.liftweb.json._

/**
 * Functions for setting up AgileSites 3
 *
 * Created by msciab on 22/10/15.
 */
trait NgSetupSupport
  extends LazyLogging
  with Encoding
  with Utils {

  val libFolder = new File(new File(sys.props("user.dir")), "project/WEB-INF/lib")
  val typesToEnable = Seq("CSElement", "SiteEntry")
  val csElements = Seq("AAAgileInfo.jsp", "AAAgileService.jsp", "AAAgileApi.txt", "AAAgileServices.txt")
  val siteEntries = Seq("AAAgileInfo", "AAAgileService", "AAAgileApi", "AAAgileServices")

  /**
   * Enable a type in the given site
   *
   * @param wem
   * @param site
   * @param stype
   */
  def enableType(wem: WemFrontend, site: String, stype: String): Unit = {

    val siteJson = wem.request(Get(s"/sites/${site}"))
    //logger.debug(pretty(render(siteJson._1)))

    val newEntry = parse(
      s"""{ "href": "${wem.base}/REST/types/${stype}",
            "name" : "${stype}" }""")
    //logger.debug(compact(render(newEntry)))
    val lookup = siteJson._1 find {
      _ == newEntry
    }

    if (lookup.isEmpty) {
      logger.debug(s"adding ${stype}")
      val newJson = siteJson._1 transform {
        case JField("type", JArray(list)) =>
          JField("type", JArray(newEntry :: list))
      }
      logger.debug("posting " + pretty(render(newJson \\ "enabledAssetTypes" \ "type")))
      wem.request(Post(s"/sites/${site}", newJson))
    }
  }

  /**
   * Load an asset map eventually deploying the info
   *
   * @param wem
   * @param site
   * @return
   */
  def loadAssetMap(wem: WemFrontend, site: String, log: sbt.Logger): Map[String, String] = {

    val map = Map.empty[String, String]

    val info = "aaagile/ElementCatalog/AAAgileInfo.jsp"
    val req = Get("?pagename=AAAgileInfo&d=&prefix=AAAgile")
    val jsonMap = wem.request(req)._1

    val jsonMap1 = if ((jsonMap \ "info") == JNothing) {
      importCSElement(wem, map, site, info, log)
      importSiteEntry(wem, map, site, "AAAgileInfo", log)
      wem.request(req)._1
    } else jsonMap

    //println(pretty(render(jsonMap1)))

    val ls = for {
      JArray(list) <- jsonMap1 \ "info"
      node <- list
    } yield {
        val JString(stype) = node \ "type"
        val JString(name) = node \ "name"
        val JString(id) = node \ "id"
        s"${stype}:${name}" -> id
      }
    ls.toSeq.toMap
  }

  def importCSElement(wem: WemFrontend, map: Map[String, String], site: String, resource: String, log: sbt.Logger): Unit = {
    // search for a cselement with a given value

    val fileName = resource.split("/").last
    val assetName = fileName.split("\\.").head
    val id = map.get(s"CSElement:${assetName}")

    if (id.nonEmpty) {
      val u = s"/sites/${site}/types/CSElement/assets/${id.get}"
      val (cur, st) = wem.request(Delete(u))
      log.debug(s"Delete ${u}:${st}")
      //print("-")
    }

    val u = s"/sites/${site}/types/CSElement/assets/0"
    val msg = WemCSElement.build(site, resource)
    val (cur, st) = wem.request(Put(u, msg))
    log.debug(s"Put ${u}:${st}")
    print(s"${assetName} ")
  }

  def importSiteEntry(wem: WemFrontend, map: Map[String, String], site: String, assetName: String, log: sbt.Logger): Unit = {
    // search for a cselement with a given value
    val id = map.get(s"SiteEntry:${assetName}")
    //val u = new java.net.URL(wem.base)

    if (id.nonEmpty) {
      val u = s"/sites/${site}/types/SiteEntry/assets/${id.get}"
      val (cur, st) = wem.request(Delete(u))
      //print("-")
      log.debug("Delete ${u}:${st}")
    }

    val u = s"/sites/${site}/types/SiteEntry/assets/0"
    //println(s"${assetName}: Put(${u}: ${pretty(render(j))}")
    val msg = Put(u, WemSiteEntry.build(site, assetName))
    val (cur, st) = wem.request(msg)
    log.debug("Put ${u}:${st}")
    print(s"${assetName} ")
  }

  def downloadJars(wem: WemFrontend, list: String, target: File, log: sbt.Logger): Unit = {
    log.debug(s"Download ${list}")
    target.mkdirs()
    val is = this.getClass.getClassLoader.getResourceAsStream(list)
    for (filename <- Source.fromInputStream(is).getLines()) {
      val file = new File(target, filename)
      if (!file.exists) {
        val u = s"?pagename=AAAgileInfo&d=&jar=/WEB-INF/lib/${filename}"
        log.debug(s"${u}")
        val req = Get(u)
        val JString(body) = wem.request(req)._1
        if(body == "") {
          println(s"not found ${filename}")
        } else  {
          writeFileBase64(file, body)
          println(filename)
        }
      }
    }
  }

  def akka = {
    val cl = getClass.getClassLoader
    val config = ConfigFactory.load(cl)
      .getConfig("sbt-web")
      .withFallback(ConfigFactory.defaultReference(cl))
    ActorSystem("sbt-web", config, cl)
  }

  // return None if ok, Some(error) otherwise
  def doSetup(url: URL, user: String, password: String, log: sbt.Logger): Option[String] = {
    try {
      val wem = new WemFrontend(akka, url, user, password)

      println("Initializing")
      typesToEnable foreach {
        enableType(wem, "AdminSite", _)
      }
      val map = loadAssetMap(wem, "AdminSite", log)
      //println(map)

      // import cselements
      print(s"Importing CSElements: ")
      csElements foreach { it: String =>
        importCSElement(wem, map, "AdminSite",
          s"aaagile/ElementCatalog/${it}", log)
      }
      println()

      // import site entries
      print(s"Importing SiteEntries: ")
      siteEntries foreach { it: String =>
        importSiteEntry(wem, map, "AdminSite", it, log)
      }
      println()

      val version = map("Info:sites.version")
      val files = s"jars.${version}.txt";
      val lib = libFolder
      downloadJars(wem, files, lib, log)
      wem.quit

      // completing setup asking for version and forcing reload
      val req = s"${url}/ContentServer?pagename=AAAgileService" +
        s"&op=version&username=${user}&password=${password}&reload=1"
      println(httpCallRaw(req))

      None
    } catch {
      case ex: Throwable =>
        ex.printStackTrace
        log.error(ex.getMessage)
        Some(ex.getMessage)
    }
  }

  // return None if ok, Some(error) otherwise
  def doSetupOnly(url: URL, user: String, password: String, site: String, file: File, log: sbt.Logger): Option[String] = {
    try {
      val wem = new WemFrontend(akka, url, user, password)

      val fileName = file.getName
      val assetName = fileName.split("\\.").head
      val map = loadAssetMap(wem, "AdminSite", log)
      val id = map.get(s"CSElement:${assetName}")

      print(s"Importing CSElements: ${assetName} ")
      if (id.nonEmpty) {
        val u = s"/sites/${site}/types/CSElement/assets/${id.get}"
        val (cur, st) = wem.request(Delete(u))
        log.debug(s"Delete ${u}:${st}")
        //print("-")
      }
      val u = s"/sites/${site}/types/CSElement/assets/0"
      val msg = WemCSElement.build(site, file)
      val (cur, st) = wem.request(Put(u, msg))
      log.debug(s"Put ${u}:${st}")
      print(s"${assetName} ")

      // completing setup asking for version and forcing reload
      val req = s"${url}/ContentServer?pagename=AAAgileService" +
        s"&op=version&username=${user}&password=${password}&" +
        "refresh=1"
      println(httpCallRaw(req))
      wem.quit

      None
    } catch {
      case ex: Throwable =>
        ex.printStackTrace
        log.error(ex.getMessage)
        Some(ex.getMessage)
    }
  }

}
