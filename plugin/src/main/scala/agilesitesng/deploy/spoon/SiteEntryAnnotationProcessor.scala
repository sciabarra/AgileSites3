package agilesitesng.deploy.spoon

import agilesites.annotations.SiteEntry
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

/**
  * Created by msciab on 06/08/15.
  */
class SiteEntryAnnotationProcessor
  extends AbstractAnnotationProcessor[SiteEntry, CtClass[_]]
    with SpoonUtils {

  def process(a: SiteEntry, cl: CtClass[_]) {
    val name = orEmpty(a.name(), cl.getSimpleName)
    val key = s"SiteEntry.$name"

    Spooler.insert(40, key,
      SpoonModel.SiteEntry(
        id=Uid.generate(key),
        name = name,
        description= s"SiteEntry for ${name}",
        wrapper = a.wrapper(),
        elementName = orEmpty(a.elementName(), name),
        ssCache = orEmpty(a.ssCache(), "false"),
        csCache = orEmpty(a.csCache(), "false"),
        criteria = a.criteria(),
        extraCriteria = a.extraCriteria()
      ))
  }
}
