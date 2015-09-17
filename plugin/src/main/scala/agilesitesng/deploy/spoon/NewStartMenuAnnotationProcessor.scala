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
    val name = cl.getSimpleName
    val description = if (a.description() == null || a.description().isEmpty) name else a.description()
    val assetType = cl.getSuperclass.getSimpleName
    Spooler.insert(70, SpoonModel.StartMenu(Uid.generate(s"StartMenu.$name"), name, description, "Content", assetType, "", Nil))
    logger.debug(s"StartMenu - name:$name description: $description assetType: $assetType menuType: Content ")
  }
}
