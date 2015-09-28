package agilesitesng.deploy.spoon

import agilesites.annotations._
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import org.slf4j.LoggerFactory
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

import scala.collection.JavaConversions._


/**
 * Created by msciab on 06/08/15.
 */
class FindStartMenuAnnotationProcessor extends AbstractAnnotationProcessor[FindStartMenu, CtClass[_]] {

  def logger = LoggerFactory.getLogger(classOf[FindStartMenuAnnotationProcessor])

  def process(a: FindStartMenu, cl: CtClass[_]) {
    val name = a.value()
    val description = if (a.description() == null || a.description().isEmpty) name else a.description()
    val assetType = cl.getSuperclass.getSimpleName
    val assetSubtype = cl.getSimpleName
    Spooler.insert(111, SpoonModel.StartMenu(Uid.generate(s"StartMenu.${cl.getSimpleName}.Search"), name, description, "Search", assetType, assetSubtype, Nil))
    logger.debug(s"StartMenu - name:$name description: $description assetType: $assetType menuType: Search ")
  }
}
