package agilesitesng.deploy.spoon

import agilesites.annotations.{FlexType, FlexFamily, Site}
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import org.slf4j.LoggerFactory
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass
import scala.collection.JavaConversions._


/**
 * Created by msciab on 06/08/15.
 */
class FlexFamilyAnnotationProcessor extends AbstractAnnotationProcessor[FlexFamily, CtClass[_]] {

  def logger =  LoggerFactory.getLogger(classOf[FlexFamilyAnnotationProcessor])

  def process(a: FlexFamily, cl: CtClass[_]) {
    val attr = a.flexAttribute()
    val content = a.flexContent()
    val parent = a.flexParent()
    val contentDef = a.flexContentDefinition()
    val parentDef = a.flexParentDefinition()
    val filter = a.flexFilter()
    val additionalTypes = a.additionalFlexTypes().map( x => s"${x.name()}~${x.parentType()}").toList
    val additionalParents = a.additionalFlexParents().toList
    val key = s"FlexFamily.$content"
    Spooler.insert(150, key, SpoonModel.FlexFamily(attr,contentDef,parentDef,content,parent,filter, additionalTypes, additionalParents))
   }

}
