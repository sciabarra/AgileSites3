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
    //cl.getDeclaringType
    Spooler.insert(50, SpoonModel.Template(
      Uid.generate(s"Template.${name}"), name, class2file(name)))
  }

}
