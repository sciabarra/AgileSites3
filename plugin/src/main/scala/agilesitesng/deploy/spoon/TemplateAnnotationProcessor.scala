package agilesitesng.deploy.spoon

import agilesites.annotations.Template
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.{CtMethod, CtClass}

/**
 * Created by msciab on 06/08/15.
 */
class TemplateAnnotationProcessor
  extends AbstractAnnotationProcessor[Template, CtMethod[_]]
  with SpoonUtils {

  def process(a: Template, mt: CtMethod[_]) {
    val name =  mt.getDeclaringType.getQualifiedName+"."+mt.getSimpleName
    val key = s"Template.$name"
    //cl.getDeclaringType
    println("**** Template "+key)
    //Spooler.insert(50, key, SpoonModel.Template(
    //  Uid.generate(key), name, class2file(name)))
  }

}
