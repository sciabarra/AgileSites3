package agilesitesng.deploy.spoon

import agilesites.annotations.Site
import agilesites.config.AgileSitesConfigKeys
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

/**
  * Created by msciab on 06/08/15.
  */
class SiteAnnotationProcessor extends AbstractAnnotationProcessor[Site, CtClass[_]] {
  def process(a: Site, cl: CtClass[_]) {
    val name = cl.getSimpleName
    val lname = name.toLowerCase
    val enabledTypes = a.enabledTypes
    val key = s"Site.${name}"
    val apiKey = s"Controller.${lname}.Api"
    val siteplanKey = s"SitePlan.${lname}.Default"
    Spooler.insert(130, key, SpoonModel.Site(Uid.generate(key), name, enabledTypes.toList))
    // register Api
    if (sys.props("spoon.controller") == "true")
      Spooler.insert(130, apiKey, SpoonModel.Controller(Uid.generate(apiKey), s"${lname}.Api", "AgileSites Api", s"${lname}.Api", "/Api.groovy", true))
    // create default SitePlan
    Spooler.insert(130, siteplanKey,
      SpoonModel.SitePlan(Uid.generate(siteplanKey), "Default", "Default"))
  }
}
