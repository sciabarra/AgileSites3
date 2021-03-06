package agilesitesng.deploy.model

/**
  * Created by msciab on 15/07/15.
  */

trait SpoonModel

object SpoonModel extends ModelUtil {

  val classTypes = List(
    classOf[Site],
    classOf[FlexFamily],
    classOf[ContentDefinition],
    classOf[ParentDefinition],
    classOf[AssetAttribute],
    classOf[Attribute],
    classOf[AttributeEditor],
    classOf[StartMenu],
    classOf[Template],
    classOf[CSElement],
    classOf[SiteEntry],
    classOf[SitePlan],
    classOf[Controller])

  case class DeployObjects(deployObjects: List[SpoonModel]) {
    def apply(n: Int) = deployObjects(n)
  }

  case class Site(id: Long, name: String, enabledTypes: List[String]) extends SpoonModel

  case class FlexFamily(attribute: String, contentDef: String, parentDef: String, content: String, parent: String, filter: String, additionalTypes: List[String], additionalParents: List[String]) extends SpoonModel

  case class AttributeEditor(id: Long, name: String, file: String) extends SpoonModel

  case class Attribute(id: Long, name: String, description: String, flexAttibuteType: String, mul: String, attributeType: String, editor: Option[String], assetType: Option[String], subtypes: List[String]) extends SpoonModel

  case class ContentDefinition(id: Long, name: String, description: String, contentType: String, parentType: String, attributeType: String, parents: List[String], attributes: List[AssetAttribute]) extends SpoonModel

  case class ParentDefinition(id: Long, name: String, description: String, parentType: String, attributeType: String, parents: List[String], attributes: List[AssetAttribute]) extends SpoonModel

  case class StartMenu(id: Long, name: String, description: String, menuType: String, assetType: String, assetSubtype: String, args: List[String]) extends SpoonModel

  case class Template(id: Long,
                      name: String,
                      description: String,
                      forType: String,
                      forSubtype: String,
                      templateType: String,
                      controller: String,
                      ssCache: String,
                      csCache: String,
                      criteria: String,
                      extraCriteria: String,
                      file: String
                     ) extends SpoonModel

  case class CSElement(id: Long,
                       name: String,
                       description: String,
                       file: String) extends SpoonModel

  case class SiteEntry(id: Long,
                       name: String,
                       description: String,
                       wrapper: Boolean,
                       elementName: String,
                       ssCache: String,
                       csCache: String,
                       criteria: String,
                       extraCriteria: String
                       ) extends SpoonModel

  case class Controller(id: Long,
                        name: String,
                        description: String,
                        classname: String,
                        file: String,
                        resource: Boolean = false) extends SpoonModel

  case class SitePlan(id: Long,
                      name: String,
                      description: String,
                      rank: Int = 2,
                      code: String = "Placed") extends SpoonModel

  case class AssetAttribute(name: String, required: Boolean) extends SpoonModel

}
