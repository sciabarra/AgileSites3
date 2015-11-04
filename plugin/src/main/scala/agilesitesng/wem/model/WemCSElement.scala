package agilesitesng.wem.model

import net.liftweb.json.JsonAST.{JObject, JString, JField}
import net.liftweb.json._
import net.liftweb.json.JsonDSL._


import java.io.File

import scala.collection.generic.SeqFactory

/**
 * Created by msciab on 24/10/15.
 */
object WemCSElement extends Encoding {

  def build(site: String, file: File) = {

    val fileName = file.getName
    val elementName = fileName.split("\\.").head
    val fileData = base64file(file)
    val now = jsonFormatDate(new java.util.Date())
    parse(
      s"""
        |{
        |"name":"${elementName}",
        |"createdby":"agilesites",
        |"createddate":"${now}",
        |"description":"AgileSites CSElement ${elementName}",
        |"publist":["${site}"],
        |"status":"ED",
        |"subtype":"",
        |"attribute": [{
        |"name":"rootelement",
        |"data":{
        |"stringValue":"agilesites/${elementName}"
        |}
        |},{
        |"name":"elementname",
        |"data":{
        |"stringValue":"agilesites/${elementName}"
        |}
        |},{
        |"name":"url",
        |"data":{
        |"blobValue":{
        |"filename":"${fileName}",
        |"foldername":"agilesites",
        |"filedata":"${fileData}",
        |"webreferences":[]
        |}
        |}
        |}]
        |}""".stripMargin)
  }


  def update(json: JValue, site: String, file: java.io.File, id: String) = {
    // update file

    val name = file.getName.split("\\.").head
    val fileData = base64file(file)
    val now = jsonFormatDate(new java.util.Date())

    json transform {

      case JField("blobValue", JObject(List(
      JField("filename", JString(filename)),
      JField("foldername", JString(foldername)),
      JField("filedata", JString(_)),
      JField("webreferences", webref)))) =>

        JField("blobValue", JObject(List(
          JField("filename", JString(filename)),
          JField("foldername", JString(foldername)),
          JField("filedata", JString(fileData)),
          JField("webreferences", webref))))

      case JObject(List(JField("name", JString("resdetails1")),
      JField("data", JObject(List(JField("stringValue", JString(_))))))) =>
        JObject(List(JField("name", JString("resdetails1")),
          JField("data", JObject(List(JField("stringValue", JString(s"eid=${id}")))))))


      case JField("updatedby", _) =>
        JField("updatedby", JString("agilesites"))

      case JField("updateddate", _) =>
        JField("updatedby", JString(now))

    }
  }
}
