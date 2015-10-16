package agilesitesng.deploy.spoon

import agilesites.annotations.Required
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.{CtField, CtClass}

/**
 * Created by msciab on 06/08/15.
 */
class RequiredAnnotationProcessor extends AbstractAnnotationProcessor[Required, CtField[_]] {

  def process(a: Required, cl: CtField[_]): Unit = {
  }
}
