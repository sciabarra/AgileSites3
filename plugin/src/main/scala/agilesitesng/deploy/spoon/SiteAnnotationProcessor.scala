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

    //println("** hello from spoon **")

    val name = cl.getSimpleName
    val enabledTypes = a.enabledTypes
    val key = s"Site.${name}"
    Spooler.insert(130, key, SpoonModel.Site(Uid.generate(key), name, enabledTypes.toList))
   }

}
