package agilesitesng.deploy.spoon

import agilesites.annotations.Site
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

/**
 * Created by msciab on 06/08/15.
 */
class SiteAnnotationProcessor extends AbstractAnnotationProcessor[Site, CtClass[_]] {
  def process(a: Site, cl: CtClass[_]) {
    val name = cl.getSimpleName
    val lname = name.toLowerCase
    val enabledTypes = a.enabledTypes
    val key = s"Site.${name}"
    val apiKey = s"Controller.${lname}.Api"
    Spooler.insert(130, key, SpoonModel.Site(Uid.generate(key), name, enabledTypes.toList))
    Spooler.insert(130, apiKey, SpoonModel.Controller(Uid.generate(apiKey), s"${lname}.Api", "AgileSites Api", s"${lname}.Api", "/Api.groovy", true))
  }
}
