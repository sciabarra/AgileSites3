package agilesitesng.deploy.spoon

import agilesites.annotations.CSElement
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

/**
 * Created by msciab on 06/08/15.
 */
class CSElementAnnotationProcessor
  extends AbstractAnnotationProcessor[CSElement, CtClass[_]]
  with SpoonUtils {

  def process(a: CSElement, cl: CtClass[_]) {
    val name = cl.getQualifiedName
    val key = s"CSElement.$name"
    Spooler.insert(50, key,
      SpoonModel.CSElement(Uid.generate(key),
        name, class2file(name)))
  }

}
