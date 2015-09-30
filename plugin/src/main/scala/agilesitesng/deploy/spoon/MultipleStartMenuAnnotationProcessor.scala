package agilesitesng.deploy.spoon

import agilesites.annotations._
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import org.slf4j.LoggerFactory
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass


/**
 * Created by msciab on 06/08/15.
 */
class MultipleStartMenuAnnotationProcessor extends AbstractAnnotationProcessor[MultipleStartMenu, CtClass[_]] {

  def logger = LoggerFactory.getLogger(classOf[MultipleStartMenuAnnotationProcessor])

  def process(an: MultipleStartMenu, cl: CtClass[_]) {
    for (a <- an.items) {
      val name = a.value()
      val description = if (a.description() == null || a.description().isEmpty) name else a.description()
      val assetType = cl.getSuperclass.getSimpleName
      val assetSubtype = cl.getSimpleName
      val args = a.args().toList
      val key = s"StartMenu.${name.filter(_ > ' ')}.ContentForm"
      Spooler.insert(110, key, SpoonModel.StartMenu(Uid.generate(key), name, description, "ContentForm", assetType, assetSubtype, args))
      logger.debug(s"StartMenu - name:$name description: $description assetType: $assetType assetSubtype: $assetSubtype menuType: ContentForm ")
    }
  }
}
