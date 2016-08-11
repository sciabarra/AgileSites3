package agilesitesng.deploy.spoon

import agilesites.annotations._
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import net.liftweb.json.{NoTypeHints, Serialization}
import org.slf4j.LoggerFactory
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass
//import templates.ContentDefinitionTemplate

import scala.collection.JavaConversions._


/**
  * Created by jelerak on 06/08/15.
  */
class ContentDefinitionAnnotationProcessor
  extends AbstractAnnotationProcessor[ContentDefinition, CtClass[_]]
  with SpoonUtils {

  def logger = LoggerFactory.getLogger(classOf[ContentDefinitionAnnotationProcessor])

  def process(a: ContentDefinition, cl: CtClass[_]) {
    val name = cl.getSimpleName
    val description = if (a.description() == null || a.description().isEmpty) name else a.description()
    val contentType = a.flexContent()
    val attributeType = a.flexAttribute()
    val parentType = a.flexParent()
    val attributes = cl.getFields collect {
      case b if b.getAnnotation(classOf[Attribute]) != null => SpoonModel.AssetAttribute(b.getSimpleName, b.getAnnotation(classOf[Required]) != null)
    }
    val parents = if (cl.getAnnotation(classOf[Parents]) != null) cl.getAnnotation(classOf[Parents]).value().toList else Nil
    val key = s"$contentType.$name"
    Spooler.insert(70, key, SpoonModel.ContentDefinition(Uid.generate(key), name, description, contentType, parentType, attributeType, parents, attributes.toList))
    logger.debug(s"Content definition - name:$name description: $description contentType: $contentType parentType: $parentType attributeType: $attributeType attributes: $attributes ")
    implicit val formats = Serialization.formats(NoTypeHints)
    val amap = attributes.map(attribute => {
      Spooler.get(90, s"$attributeType.${attribute.name}") match {
        case Some(x) => val attributeModel = x.asInstanceOf[SpoonModel.Attribute]
          Serialization.write(Map("name" -> attributeModel.name, "type" -> attributeModel.attributeType, "assettype" -> attributeModel.assetType.getOrElse(""), "mul" -> attributeModel.mul))
        //s"${attributeModel.name}~${attributeModel.attributeType}~${attributeModel.assetType.getOrElse("")}~${attributeModel.mul}"
        case None => ""
      }
    })
    //val t = new ContentDefinitionTemplate("[" + amap.filter(_ != "").mkString(",") + "]")
    //t.apply(cl)
    //addController(cl.getSimpleName, cl.getQualifiedName)
  }

}
