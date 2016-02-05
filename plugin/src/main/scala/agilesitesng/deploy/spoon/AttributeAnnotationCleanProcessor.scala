package agilesitesng.deploy.spoon

import agilesites.annotations.Attribute
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.{CtField, CtClass}

/**
 * Created by msciab on 06/08/15.
 */
class AttributeAnnotationCleanProcessor extends AbstractAnnotationProcessor[Attribute, CtField[_]] with SpoonUtils {

  def process(a: Attribute, cl: CtField[_]): Unit = {
    val defField = getFactory().Core().createField()
    val defType = getFactory().Core().createTypeReference()
    defType.setSimpleName("def")
    defField.setSimpleName(cl.getSimpleName)

    defField.setType(defType)
    cl.replace(defField)
  }
}
