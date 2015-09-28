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
class NewStartMenuAnnotationProcessor extends AbstractAnnotationProcessor[NewStartMenu, CtClass[_]] {

  def logger = LoggerFactory.getLogger(classOf[NewStartMenuAnnotationProcessor])

  def process(a: NewStartMenu, cl: CtClass[_]) {
    val name = a.value()
    val description = if (a.description() == null || a.description().isEmpty) name else a.description()
    val assetType = cl.getSuperclass.getSimpleName
    val assetSubtype = cl.getSimpleName
    val args = a.args().toList
    Spooler.insert(110, SpoonModel.StartMenu(Uid.generate(s"StartMenu.${cl.getSimpleName}.ContentForm"), name, description, "ContentForm", assetType, assetSubtype, args))
    logger.debug(s"StartMenu - name:$name description: $description assetType: $assetType assetSubtype: $assetSubtype menuType: ContentForm ")
  }
}
