package agilesitesng.deploy.spoon

import agilesites.annotations.Parents
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

/**
 * Created by msciab on 06/08/15.
 */
class ParentsAnnotationProcessor extends AbstractAnnotationProcessor[Parents, CtClass[_]] {

  def process(a: Parents, cl: CtClass[_]) {
  }
}
