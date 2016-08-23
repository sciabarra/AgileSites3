package agilesitesng.deploy.spoon

import agilesites.annotations.Template
import spoon.processing.AbstractAnnotationProcessor
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.reflect.declaration.{CtClass}

/**
  * Created by msciab on 06/08/15.
  */
class TemplateClassAnnotationProcessor
  extends AbstractAnnotationProcessor[Template, CtClass[_]]
    with SpoonUtils {

  def generate(name: String, forType: String,  className: String) = {
    val filename = s"jsp/${sys.props("spoon.site")}/${orEmpty(forType, "Typeless")}/${name}.jsp"
    writeFileOutdir(filename, JspUtils.streamer(className))
  }

  def process(a: Template, cl: CtClass[_]) {
    val name = orEmpty(a.name(), cl.getSimpleName)
    val key = s"Template.$name"
    val templateType = if (a.layout()) "l"
    else if (a.external()) "x" else "b"

    Spooler.insert(60, key,
      SpoonModel.Template(
        id = Uid.generate(key),
        name = name,
        description = s"Template for ${name}",
        forType = a.forType(),
        forSubtype = a.forSubtype(),
        templateType = templateType,
        controller = "",
        ssCache = orEmpty(a.ssCache(), "false"),
        csCache = orEmpty(a.csCache(), "false"),
        criteria = a.criteria(),
        extraCriteria = a.extraCriteria(),
        file = generate(name, a.forType(), cl.getQualifiedName)
      ))
  }

}
