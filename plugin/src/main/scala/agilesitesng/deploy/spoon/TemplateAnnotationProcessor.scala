package agilesitesng.deploy.spoon

import agilesites.api.Picker
import agilesites.annotations.Template
import agilesitesng.preprocess.PickerImpl
import spoon.processing.AbstractAnnotationProcessor
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.reflect.declaration.{CtMethod, CtClass}

/**
  * Created by msciab on 06/08/15.
  */
class TemplateAnnotationProcessor
  extends AbstractAnnotationProcessor[Template, CtMethod[_]]
  with SpoonUtils {

  def preProcess(a: Template, mt: CtMethod[_]) = {
    val name = orEmpty(a.name(), mt.getSimpleName)
    val className = mt.getDeclaringType.getQualifiedName
    val cls = Class.forName(className)
    val method = cls.getDeclaredMethod(mt.getSimpleName, classOf[Picker])
    val obj = cls.newInstance
    val input = PickerImpl.load(a.from(), a.pick())
    val output = method.invoke(obj, input).asInstanceOf[String]
    val filename = s"jsp/${orEmpty(a.forType(), "Typeless")}/${name}.jsp"
    writeFileOutdir(filename, JspUtils.wrapAsJsp(output))
  }

  def process(a: Template, mt: CtMethod[_]) {
    val name = orEmpty(a.name(), mt.getSimpleName)
    val key = s"Template.$name"
    val className = mt.getDeclaringType.getQualifiedName
    val templateType = if (a.layout()) 'l'
    else if (a.external()) 'x' else 'b'

    Spooler.insert(60, key,
      SpoonModel.Template(
        id = Uid.generate(key),
        name = name,
        description = s"Template for ${name}",
        forType = a.forType(),
        forSubtype = a.forSubtype(),
        templateType = templateType,
        controller = orEmpty(a.controller(), className),
        ssCache = orEmpty(a.ssCache(), "false"),
        csCache = orEmpty(a.csCache(), "false"),
        criteria = a.criteria(),
        extraCriteria = a.extraCriteria(),
        file = preProcess(a, mt)
      ))

    mt.getDeclaringType.removeMethod(mt)
  }

}
