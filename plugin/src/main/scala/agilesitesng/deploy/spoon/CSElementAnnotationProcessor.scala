package agilesitesng.deploy.spoon

import agilesites.annotations.CSElement
import agilesites.api.Picker
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import agilesitesng.preprocess.PickerImpl
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.{CtMethod, CtClass}

/**
 * Created by msciab on 06/08/15.
 */
class CSElementAnnotationProcessor
  extends AbstractAnnotationProcessor[CSElement, CtMethod[_]]
  with SpoonUtils {

  def process(a: CSElement, mt: CtMethod[_]) {
    val name = mt.getDeclaringType.getQualifiedName+"."+mt.getSimpleName
    val key = s"CSElement.$name"

    val className = mt.getDeclaringType.getQualifiedName

    val cls = Class.forName(className)
    val obj = cls.newInstance
    val method = cls.getDeclaredMethod(mt.getSimpleName, classOf[Picker])

    println("**** CSElement "+key)
    val out = method.invoke(obj, PickerImpl.load(a.from(), a.pick())).asInstanceOf[String]
    println(out)

    //Spooler.insert(50, key,
    //  SpoonModel.CSElement(Uid.generate(key),
    //    name, class2file(name)))
  }

}
