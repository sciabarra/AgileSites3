package agilesitesng.deploy.spoon

import agilesites.annotations.{Parents, Required, Attribute, ParentDefinition}
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import org.slf4j.LoggerFactory
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass
import scala.collection.JavaConversions._

/**
 * Created by msciab on 06/08/15.
 */
class ParentDefinitionAnnotationProcessor
  extends AbstractAnnotationProcessor[ParentDefinition, CtClass[_]]
  with SpoonUtils
{
  def logger =  LoggerFactory.getLogger(classOf[ParentDefinitionAnnotationProcessor])

  def process(a: ParentDefinition, cl: CtClass[_]) {
    val name = cl.getSimpleName
    val description = if (a.description() == null || a.description().isEmpty) name else  a.description()
    val parentType = a.flexParent()
    val attributeType = a.flexAttribute()
    val attributes = cl.getFields  collect {
      case b if b.getAnnotation(classOf[Attribute]) != null => SpoonModel.AssetAttribute(b.getSimpleName, b.getAnnotation(classOf[Required]) != null)
    }
    val parents = if (cl.getAnnotation(classOf[Parents]) != null) cl.getAnnotation(classOf[Parents]).value().toList else Nil
    val key = s"$parentType.$name"
    Spooler.insert(80, key, SpoonModel.ParentDefinition(Uid.generate(key), name, description, parentType, attributeType, parents, attributes.toList))
    logger.debug(s"Parent definition - name:$name description: $description parentType: $parentType attributeType: $attributeType attributes: $attributes ")
    addController(cl.getQualifiedName)
  }
}
