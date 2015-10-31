package agilesitesng.wem.model

import java.io.File
import agilesitesng.wem.model.WemCSElement._
import net.liftweb.json._

/**
 * Created by msciab on 24/10/15.
 */
object WemTemplate extends Encoding {
  def build(site: String, file: File) = {

    val fileName = file.getName
    val elementName = fileName.split("\\.").head
    val fileData = base64file(file)
    val now = jsonFormatDate(new java.util.Date())

    val json = parse(
      s"""
        |{
        |  "name":"${elementName}",
        |  "createdby":"agilesites",
        |  "createddate":"${now}",
        |  "description":"AgileSites Template ${elementName}",
        |  "publist":["${site}"],
        |  "status":"PL",
        |  "subtype":"",
        |  "attribute":[{
        |    "name":"category",
        |    "data":{
        |      "stringValue":"a"
        |    }
        |  },{
        |    "name":"rootelement",
        |    "data":{
        |      "stringValue":"agilesites/${elementName}"
        |    }
        |  },{
        |    "name":"ttype",
        |    "data":{
        |      "stringValue":"x"
        |    }
        |  },{
        |    "name":"pagecriteria",
        |    "data":{
        |      "stringList":["ab","c","cid","context","d","deviceid","p","rendermode","site","sitepfx","ft_ss"]
        |    }
        |  },{
        |    "name":"element",
        |    "data":{
        |      "structList":[{
        |        "item":[{
        |          "name":"elementname",
        |          "data":{
        |            "stringValue":"agilesites/${elementName}"
        |          }
        |        },{
        |          "name":"siteentry",
        |          "data":{
        |            "structList":[{
        |              "item":[{
        |                "name":"defaultarguments",
        |                "data":{
        |                  "structList":[{
        |                    "item":[{
        |                      "name":"name",
        |                      "data":{
        |                        "stringValue":"rendermode"
        |                      }
        |                    },{
        |                      "name":"value",
        |                      "data":{
        |                        "stringValue":"live"
        |                      }
        |                    }]
        |                  },{
        |                    "item":[{
        |                      "name":"name",
        |                      "data":{
        |                        "stringValue":"site"
        |                      }
        |                    },{
        |                      "name":"value",
        |                      "data":{
        |                        "stringValue":"${site}"
        |                      }
        |                    }]
        |                  }]
        |                }
        |              },{
        |                "name":"pagename",
        |                "data":{
        |                  "stringValue":"${elementName}"
        |                }
        |              }]
        |            }]
        |          }
        |        },{
        |          "name":"sscacheinfo",
        |          "data":{
        |            "stringValue":"false"
        |          }
        |        },{
        |          "name":"cscacheinfo",
        |          "data":{
        |            "stringValue":"false"
        |          }
        |        },{
        |          "name":"csstatus",
        |          "data":{
        |            "stringValue":"live"
        |          }
        |        },{
        |          "name":"url",
        |          "data":{
        |            "blobValue":{
        |              "filename":"agilesites/${fileName}",
        |              "foldername":"",
        |              "filedata":"${fileData}",
        |              "webreferences":[]
        |            }
        |          }
        |        }]
        |      }]
        |    }
        |  },{
        |    "name":"applicablesubtypes",
        |    "data":{
        |      "stringList":["*"]
        |    }
        |  }],
        |  "dimension":[],
        |  "dimensionParent":[],
        |  "parent":[]
        |}
        |
      """.stripMargin)
  }

  def update(url:
             java.net.URL, site: String, file:
             java.io.File,
             json: JValue)
  = {
    // update file
    // fix base
    // remove useless stuff?
    //pretty(render(assetJson))
    json
  }
}
