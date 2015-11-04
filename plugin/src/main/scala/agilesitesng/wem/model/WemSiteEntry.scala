package agilesitesng.wem.model

import java.io.File
import agilesitesng.wem.model.WemCSElement._
import net.liftweb.json.JsonAST.{JString, JObject, JField}
import net.liftweb.json._

/**
 * Created by msciab on 24/10/15.
 */
object WemSiteEntry extends Encoding {
  def build(site: String, elementName: String) = {

    val now = jsonFormatDate(new java.util.Date())

    parse(
      s"""
        |{
        |"name":"${elementName}",
        |"createdby":"agilesites",
        |"createddate":"${now}",
        |"description":"",
        |"publist":["${site}"],
        |"status":"ED",
        |"subtype":"",
        |"attribute":[{
        |"name":"startdate",
        |"data":{
        |
        |}
        |},{
        |"name":"enddate",
        |"data":{
        |
        |}
        |},{
        |"name":"filename",
        |"data":{
        | "stringValue":""
        |}
        |},{
        |"name":"path",
        |"data":{
        | "stringValue":""
        |}
        |},{
        |"name":"template",
        |"data":{
        | "stringValue":"OpenMarket/SiteEntryTemplate"
        |}
        |},{
        |"name":"urlexternaldoc",
        |"data":{
        |
        |}
        |},{
        |"name":"externaldoctype",
        |"data":{
        | "stringValue":""
        |}
        |},{
        |"name":"urlexternaldocxml",
        |"data":{
        |
        |}
        |},{
        |"name":"fwtags",
        |"data":{
        | "stringList":[]
        |}
        |},{
        |"name":"Webreference",
        |"data":{
        | "webreferenceList":[]
        |}
        |},{
        |"name":"category",
        |"data":{
        | "stringValue":""
        |}
        |},{
        |"name":"pagename",
        |"data":{
        | "stringValue":"${elementName}"
        |}
        |},{
        |"name":"cs_wrapper",
        |"data":{
        | "stringValue":"n"
        |}
        |},{
        |"name":"cselement_id",
        |"data":{
        | "stringValue":"CSID:0"
        |}
        |},{
        |"name":"controller",
        |"data":{
        | "stringValue":""
        |}
        |},{
        |"name":"acl",
        |"data":{
        | "stringValue":""
        |}
        |},{
        |"name":"cscacheinfo",
        |"data":{
        | "stringValue":"false"
        |}
        |},{
        |"name":"csstatus",
        |"data":{
        | "stringValue":"live"
        |}
        |},{
        |"name":"defaultarguments",
        |"data":{
        | "structList":[{
        |   "item":[{
        |     "name":"name",
        |     "data":{
        |       "stringValue":"rendermode"
        |     }
        |   },{
        |     "name":"value",
        |     "data":{
        |       "stringValue":"live"
        |     }
        |   }]
        | },{
        |   "item":[{
        |     "name":"name",
        |     "data":{
        |       "stringValue":"seid"
        |     }
        |   },{
        |     "name":"value",
        |     "data":{
        |       "stringValue":"SEID:0"
        |     }
        |   }]
        | },{
        |   "item":[{
        |     "name":"name",
        |     "data":{
        |       "stringValue":"site"
        |     }
        |   },{
        |     "name":"value",
        |     "data":{
        |       "stringValue":"${site}"
        |     }
        |   }]
        | }]
        |}
        |},{
        |"name":"pagecriteria",
        |"data":{
        | "stringList":["navid","rendermode","seid","site","sitepfx","ft_ss"]
        |}
        |},{
        |"name":"rootelement",
        |"data":{
        | "stringValue":"agilesites/${elementName}"
        |}
        |},{
        |"name":"sscacheinfo",
        |"data":{
        | "stringValue":"false"
        |}
        |},{
        |"name":"pageletonly",
        |"data":{
        | "stringValue":"false"
        |}
        |}],
        |"dimension":[],
        |"dimensionParent":[],
        |"parent":[]
        |}
      """.stripMargin)
  }

  def update(json: JValue, site: String, name: String, id: String, csid: String) = {
    val now = jsonFormatDate(new java.util.Date())
    json transform {

      /*case JObject(List(JField("name", JString("resdetails1")),
      JField("data", JObject(List(JField("stringValue", JString(_))))))) =>
        JObject(List(JField("name", JString("resdetails1")),
          JField("data", JObject(List(JField("stringValue", JString(s"seid=${id}")))))))
       case JObject(List(JField("name", JString("cselement_id")),
      JField("data", JObject(List(JField("stringValue", JString(_))))))) =>
        JObject(List(JField("name", JString("cselement_id")),
          JField("data", JObject(List(JField("stringValue", JString(s"CSElement:${csid}")))))))*/

      case JField("data", JObject(List(JField("stringValue", JString("CSID:0"))))) =>
        JField("data", JObject(List(JField("stringValue", JString(s"CSElement:${csid}")))))

      case JField("data", JObject(List(JField("stringValue", JString("SEID:0"))))) =>
        JField("data", JObject(List(JField("stringValue", JString(s"${id}")))))

      case JField("updatedby", _) =>
        JField("updatedby", JString("agilesites"))

      case JField("updateddate", _) =>
        JField("updatedby", JString(now))

    }
  }
}
