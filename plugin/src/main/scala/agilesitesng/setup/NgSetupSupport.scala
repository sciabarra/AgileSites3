package agilesitesng.setup

import java.io.File
import java.net.URL
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
  with Encoding {

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
  def loadAssetMap(wem: WemFrontend, site: String): Map[String, String] = {

    val map = Map.empty[String, String]

    val info = "aaagile/ElementCatalog/AAAgileInfo.jsp"
    val req = Get("?pagename=AAAgileInfo&d=&prefix=AAAgile")
    val jsonMap = wem.request(req)._1

    val jsonMap1 = if ((jsonMap \ "info") == JNothing) {
      importCSElement(wem, map, site, info)
      importSiteEntry(wem, map, site, "AAAgileInfo")
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

  def importCSElement(wem: WemFrontend, map: Map[String, String], site: String, resource: String): Unit = {
    // search for a cselement with a given value

    val fileName = resource.split("/").last
    val assetName = fileName.split("\\.").head
    val id = map.get(s"CSElement:${assetName}")

    if (id.nonEmpty) {
      val u = s"/sites/${site}/types/CSElement/assets/${id.get}"
      print(s">>>>Delete ${u}")
      val (cur, st) = wem.request(Delete(u))
      println(s":${st}")
    }

    val u = s"/sites/${site}/types/CSElement/assets/0"
    val msg = WemCSElement.build(site, resource)
    print(s">>>>Put ${u}")
    val (cur, st) = wem.request(Put(u, msg))
    println(s":${st}")
  }

  def importSiteEntry(wem: WemFrontend, map: Map[String, String], site: String, assetName: String): Unit = {
    // search for a cselement with a given value
    val id = map.get(s"SiteEntry:${assetName}")
    //val u = new java.net.URL(wem.base)

    if (id.nonEmpty) {
      val u = s"/sites/${site}/types/SiteEntry/assets/${id.get}"
      print(s">>Delete ${u}")
      val (cur, st) = wem.request(Delete(u))
      print(s"${st}\n")
    }

    val u = s"/sites/${site}/types/SiteEntry/assets/0"
    //println(s"${assetName}: Put(${u}: ${pretty(render(j))}")
    print(s">>Put ${u}")
    val msg = Put(u, WemSiteEntry.build(site, assetName))
    val (cur, st) = wem.request(msg)
    println(s":${st}")
  }

  def downloadJars(wem: WemFrontend, list: String, target: File): Unit = {
    println(s">>>> Download ${list}")
    target.mkdirs()
    val is = this.getClass.getClassLoader.getResourceAsStream(list)
    for (filename <- Source.fromInputStream(is).getLines()) {
      val file = new File(target, filename)
      if (file.exists) {
        println(s"Exist ${filename}, skipping.")
      } else {
        println(s">>>>${filename}")
        val u = s"?pagename=AAAgileInfo&d=&jar=/WEB-INF/lib/${filename}"
        println(u)
        val req = Get(u)
        val JString(body) = wem.request(req)._1
        writeFileBase64(file, body)
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
  def doSetup(url: URL, user: String, password: String): Option[String] = {

    try {

      //println("Reading: ")
      //println(this.getClass.getClassLoader.getResourceAsStream("application.conf").read())

      val wem = new WemFrontend(akka, url, user, password)

      println(">> Enabling Types")
      typesToEnable foreach {
        enableType(wem, "AdminSite", _)
      }

      println(">> Loading Asset Map")
      val map = loadAssetMap(wem, "AdminSite")
      println(map)

      // import cselements
      csElements foreach { it: String =>
        println(s">> Importing CSElement:${it}")
        importCSElement(wem, map, "AdminSite",
          s"aaagile/ElementCatalog/${it}")
      }

      // import site entries
      siteEntries foreach { it: String =>
        println(s">> Importing SiteEntry:${it}")
        importSiteEntry(wem, map, "AdminSite", it)
      }

      val version = map("Info:sites.version")
      val files = s"jars.${version}.txt";
      val lib = libFolder // new File(libFolder, sys.props.getOrElse("profile", "") + version)

      downloadJars(wem, files, lib)
      wem.quit
      /*templates foreach { filename: String =>
        importTemplate(wem, "AdminSite", new File(importFolder, filename))
      }*/

      None
    } catch {
      case ex: Throwable =>
        ex.printStackTrace
        logger.error("Error in setup", ex)
        Some(ex.getMessage)
    }
  }

}
