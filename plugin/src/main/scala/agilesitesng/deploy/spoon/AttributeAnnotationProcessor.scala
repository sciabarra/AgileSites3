package agilesitesng.deploy.spoon

import java.lang.annotation.Annotation

import agilesites.annotations._
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import org.slf4j.LoggerFactory
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.{CtClass, CtAnnotation, CtField}
import spoon.reflect.reference.{CtFieldReference, CtTypeReference}
import spoon.support.reflect.reference.CtArrayTypeReferenceImpl
import spoon.template.Substitution

import scala.collection.JavaConversions._

/**
 * Created by msciab on 06/08/15.
 */
class AttributeAnnotationProcessor extends AbstractAnnotationProcessor[Attribute, CtField[_]] {

  def logger = LoggerFactory.getLogger(classOf[AttributeAnnotationProcessor])

  def process(a: Attribute, cl: CtField[_]) {
    //Substitution.insertAll(cl.getParent(classOf[CtClass[_]]),new FieldAccessTemplate[Attribute](cl.getType, cl.getSimpleName))
    val name = cl.getSimpleName

    val description = if (a.description() == null || a.description().isEmpty) name else a.description()
    val fieldClass = cl.getReference.getType.getActualClass
    val multiple = fieldClass.isArray
    val editor = a.editor() match {
      case b if b.isEmpty => None
      case b => Some(b)
    }
    val attributeClass = if (multiple) fieldClass.getComponentType else fieldClass
    val flexAttributeType = cl.getParent match {
      case cd if cd.getAnnotation(classOf[ContentDefinition]) != null => cd.getAnnotation(classOf[ContentDefinition]).flexAttribute()
      case cd if cd.getAnnotation(classOf[ParentDefinition]) != null => cd.getAnnotation(classOf[ParentDefinition]).flexAttribute()
    }
    val attributeType = attributeClass match {
      case ba if ba == classOf[agilesitesng.api.BlobAttribute] => "blob"
      case st if st == classOf[String] => "string"
      case fa if fa == classOf[Float] => "float"
      case ia if ia == classOf[Integer] => "int"
      case da if da == classOf[java.util.Date] => "date"
      case as if as == classOf[agilesitesng.api.AssetAttribute[_]] => "asset"
      case _ => "unknown"
    }
    val (assetType, assetSubtypes) = attributeType match {
      case "asset" =>
        val subtypes = cl.getAnnotations collect {
          case b if b.getAnnotationType.getActualClass == classOf[AssetSubtypes] => b.getActualAnnotation.asInstanceOf[AssetSubtypes].values()
        }
        val componentType  = if (multiple) {
          cl.getReference.getType.asInstanceOf[CtArrayTypeReferenceImpl[_]].getComponentType
        }
        else {
          cl.getReference.getType
        }
        val assetType =  componentType.getActualTypeArguments.get(0)
        // remove type from field
        componentType.removeActualTypeArgument(assetType)
        val assetSubtypes = getSubtype(assetType)  match {
          case x:Some[CtTypeReference[_]] => subtypes.flatten.toList :+ x.get.getSimpleName
          case None => subtypes.flatten.toList
        }
        (Some(assetType.getSimpleName), assetSubtypes)
      case _ => (None, Nil)
    }
    val mul = if (multiple) "O" else "S"
    logger.debug(s"$flexAttributeType - name:$name description: $description attributeType: $attributeType mul: $mul editor: $editor assetType: $assetType subtypes: $assetSubtypes")
    val key = s"$flexAttributeType.$name"
    Spooler.insert(90, key, SpoonModel.Attribute(Uid.generate(key), name, description, flexAttributeType, mul, attributeType, editor, assetType, assetSubtypes))
  }

  def getSubtype(ctTypeReference: CtTypeReference[_]) = {
    ctTypeReference.getActualTypeArguments.headOption
  }

  override def shoudBeConsumed(annotation: CtAnnotation[_ <: Annotation]): Boolean = false
}
