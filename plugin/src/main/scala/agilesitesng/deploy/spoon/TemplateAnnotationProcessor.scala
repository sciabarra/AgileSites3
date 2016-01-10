package agilesitesng.deploy.spoon

import agilesites.api.Picker
import agilesites.annotations.Template
import agilesitesng.preprocess.PickerImpl
import agilesitesng.processors.DefinitionHelper
import spoon.processing.AbstractAnnotationProcessor
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.reflect.declaration.{CtParameter, CtMethod, CtClass}
import scala.collection.JavaConversions._

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
    val params = mt.getParameters map (x => x.getReference.getType.getActualClass)
    // create an instance of the annotated method
    val method = cls.getDeclaredMethod(mt.getSimpleName, params:_*)
    val obj = cls.newInstance
    //val input = PickerImpl.load(a.from(), a.pick())
    // create instances of all the parameters of type DefinitionHelper

    /*
    val objs = input +: (params filter(x => x == classOf[DefinitionHelper]) map(x => {
        val assetName = s"${mt.getSimpleName}_${x.getSimpleName}"
        val objParam = x.getConstructor(classOf[String]).newInstance(assetName)
        objParam.asInstanceOf[Object]
      }
    )).toSeq

     */
    val objs = params map {
      case dh if classOf[DefinitionHelper].isAssignableFrom(dh) => {
        val assetName = s"${mt.getSimpleName}_${dh.getSimpleName}"
        val objParam = dh.getConstructor(classOf[String]).newInstance(assetName)
        objParam.asInstanceOf[Object]
      }
      case p if p == classOf[Picker] =>
        PickerImpl.load(a.from(), a.pick())
      case x => x.newInstance().asInstanceOf[Object]
    }

    val output = method.invoke(obj, objs.toSeq:_*).asInstanceOf[String]
    val filename = s"jsp/${orEmpty(a.forType(), "Typeless")}/$name.jsp"
    writeFileOutdir(filename, JspUtils.wrapAsJsp(output))
  }

  def process(a: Template, mt: CtMethod[_]) {
    val name = orEmpty(a.name(), mt.getSimpleName)
    val key = s"Template.$name"
    val className = mt.getDeclaringType.getQualifiedName
    val templateType = if (a.layout()) "l"
    else if (a.external()) "x" else "b"

    Spooler.insert(a.priority(), key,
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
