package agilesitesng.deploy.actor

import agilesitesng.Utils
import agilesitesng.deploy.model.SpoonModel
import agilesitesng.deploy.model.SpoonModel._

/**
 * Created by msciab on 20/08/15.
 */
class Decoder(site: String, username: String, password: String, map: Map[String,String]) extends Utils {

  /**
   * @return a map ready to be deployed
   */
  def deploy(value: String, id: Long, name: String, description: String, t2: Tuple2[Symbol, String]*) =
    t2.map(x => x._1.name -> x._2).toMap +
      ("op" -> "deploy") +
      ("value" -> value) +
      ("cid" -> id.toString) +
      ("name" -> name) +
      ("description" -> description) +
      ("site" -> site) +
      ("username" -> username) +
      ("password" -> password)

  def readAssetId(c:String, name:String) = map.getOrElse(s"$c.$name", "-1")

  def apply(model: SpoonModel): Map[String, String] = model match {

    //TODO add description here
    case AttributeEditor(id, name, file) =>
      deploy("AttributeEditor", id, name, name,
        'cid -> id.toString,
        'xml -> readFile(file))

    // TODO mul cab be Single, Multiple and ORDERED - need another field
    case Attribute(id, name, description, flexAttributeType, mul, attributeType, editor, assetType, subtypes) =>
      deploy("Attribute", id, name, description,
        'type -> attributeType,
        'c -> flexAttributeType,
        'mul -> mul,
        'existDep -> "false",
        'notEmbedded -> "false",
        'attributetype -> readAssetId("AttrTypes", editor.getOrElse("")),
        'assettypename -> assetType.getOrElse(""),
        'assetsubtypename -> subtypes.mkString("|")
      )

   case ParentDefinition(id, name, description, parentType, attributeType, parents, attributes) =>
      deploy("ParentDefinition", id, name, description,
        'c -> parentType,
        'attributeType -> attributeType,
        'parent -> parents.mkString("|"),
        'attributes -> attributes.map(x => s"${x.required}:${readAssetId(attributeType,x.name)}").mkString("|"),
        'parents -> parents.map(x => s"${readAssetId(parentType,x)}").mkString("|")
      )

    case ContentDefinition(id, name, description, contentType, parentType, attributeType, parents, attributes) =>
      deploy("ContentDefinition", id, name, description,
        'c -> contentType,
        'attributeType -> attributeType,
        'parent -> parents.mkString("|"),
        'attributes -> attributes.map(x => s"${x.required}:${readAssetId(attributeType,x.name)}").mkString("|"),
        'parents -> parents.map(x => s"${readAssetId(parentType,x)}").mkString("|")
      )

    case FlexFamily(attr,contentDef,parentDef,content,parent,filter) => Map(
      "op" -> "flexFamily",
      "flexAttribute" -> attr,
      "flexParentDef" -> parentDef,
      "flexContentDef" -> contentDef,
      "flexParent" -> parent,
      "flexContent" -> content,
      "flexFilter" -> filter)

    case Site(id, name, enabledTypes) => Map(
      "op" -> "site",
      "id" -> id.toString,
      "name" -> name,
      "enabledTypes" -> enabledTypes.mkString("|"))

    case Controller(id, name, classname, file) => deploy("Controller", id, name, classname,
      'filename -> new java.io.File(file).getName,
      'filefolder -> name.split("\\.").init.mkString("WCS_Controller/", "/", "/"),
      'fileext -> file.split("\\.").last,
      'filebody -> readFile(file))

    case StartMenu(id, name, description, menuType, assetType, assetSubtype, args) => Map(
      "op" -> "startmenu",
      "id" -> id.toString,
      "name" -> name,
      "site" -> site,
      "description" -> description,
      "menuType" -> menuType,
      "assetType" -> assetType,
      "assetSubtype" -> assetSubtype,
      "args" -> args.mkString("|"))

    //case CSElement(id, name) => deploy("CSElement", id, name, name)

    //case Template(id, name) => deploy("Template", id, name, name)

    //case SiteEntry(id, name) => deploy("SiteEntry", id, name, name)

    case x => Map("op" -> "echo",
      "value" -> s"${x.getClass} not recognized")
  }

}
