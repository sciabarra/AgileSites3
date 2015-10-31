package agilesitesng

import java.io.File

import agilesitesng.wem.WemFrontend
import agilesitesng.wem.actor.Protocol.{Reply, Get, Post, Put}
import agilesitesng.wem.model.{WemCSElement, WemSiteEntry}
import com.typesafe.scalalogging.slf4j.LazyLogging
import net.liftweb.json.JsonAST.{JArray, JNothing}
import net.liftweb.json._

/**
 * Functions for setting up AgileSites 3
 *
 * Created by msciab on 22/10/15.
 */
trait AgileSitesNgSetupSupport extends LazyLogging {

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

  def findAssetIdByName(assetMap: Map[String, String], assetType: String, assetName: String): Option[String]
  = assetMap.get(s"${assetType}:${assetName}")

  /**
   * Load an asset map eventually deploying the info
   *
   * @param wem
   * @param site
   * @param info
   * @return
   */
  def loadAssetMap(wem: WemFrontend, site: String, base: File): Map[String, String] = {

    val map = Map.empty[String, String]

    val info = new File(base, "AAAgileInfo.jsp")
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

  /**
   * If you do not have a CSElement in the map it will create one otherwise it will update
   *
   * @param wem
   * @param map
   * @param site
   * @param file
   */
  def importCSElement(wem: WemFrontend, map: Map[String, String], site: String, file: java.io.File): Unit = {
    // search for a cselement with a given value
    val assetName = file.getName.split("\\.").head
    val id = map.get(s"CSElement:${assetName}")
    val url = new java.net.URL(wem.base)
    val msg = if (id.isEmpty) {
      val u = s"/sites/${site}/types/CSElement/assets/0"
      val j = WemCSElement.build(site, file)
      println(s">>>>Put ${u}")
      Put(u, j)
    } else {
      val u = s"/sites/${site}/types/CSElement/assets/${id.get}"
      val (cur, _) = wem.request(Get(u))
      val j = WemCSElement.update(cur, site, file, id.get)
      println(s">>>>Post ${u}")
      Post(u, j)
    }
    val (_,s) = wem.request(msg)
    println(s":${s}")
  }

  def importSiteEntry(wem: WemFrontend, map: Map[String, String], site: String, assetName: String): Unit = {
    // search for a cselement with a given value
    val id = map.get(s"SiteEntry:${assetName}")
    val csid = map.get(s"CSElement:${assetName}")
    val url = new java.net.URL(wem.base)
    val msg = if (id.isEmpty) {
      val u = s"/sites/${site}/types/SiteEntry/assets/0"
      //println(s"${assetName}: Put(${u}: ${pretty(render(j))}")
      print(s">>Put ${u}")
      Put(u, WemSiteEntry.build(site, assetName))
    } else {
      val u = s"/sites/${site}/types/SiteEntry/assets/${id.get}"
      val (cur, _) = wem.request(Get(u))
      //println(s"prima: ${compact(render(cur))}")
      val j = WemSiteEntry.update(cur, site, assetName, id.get, csid.get)
      //println(s"dopo: ${compact(render(j))}")
      print(s"Post(${u})")
      Post(s"/types/CSElement/sites/${site}/assets", j)
    }
    wem.request(msg)
    val (_,s) = wem.request(msg)
    println(s":${s}")
  }

}
