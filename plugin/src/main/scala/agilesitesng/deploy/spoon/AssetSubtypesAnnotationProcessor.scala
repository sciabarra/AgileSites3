package agilesitesng.deploy.spoon

import agilesites.annotations.{AssetSubtypes, Required}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtField

/**
 * Created by msciab on 06/08/15.
 */
class AssetSubtypesAnnotationProcessor extends AbstractAnnotationProcessor[AssetSubtypes, CtField[_]] {

  def process(a: AssetSubtypes, cl: CtField[_]): Unit = {
  }
}
