package agilesitesng.deploy.spoon

import agilesites.annotations.SiteEntry
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

/**
 * Created by msciab on 06/08/15.
 */
class SiteEntryAnnotationProcessor extends AbstractAnnotationProcessor[SiteEntry, CtClass[_]] {

  def process(a: SiteEntry, cl: CtClass[_]) {
    val name = cl.getQualifiedName
    val key = s"SiteEntry.$name"
    Spooler.insert(50, key, SpoonModel.SiteEntry(Uid.generate(key), name, s"SiteEntry for ${name}"))
  }

}
