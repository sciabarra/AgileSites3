package agilesitesng.deploy.spoon

import agilesites.annotations.Type
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

/**
 * Created by msciab on 06/08/15.
 */
class TypeAnnotationProcessor extends AbstractAnnotationProcessor[Type, CtClass[_]]with SpoonUtils {

  def process(a: Type, cl: CtClass[_]) {
    val name = cl.getQualifiedName
    addController(cl.getSimpleName, name, a.priority())
  }
}
