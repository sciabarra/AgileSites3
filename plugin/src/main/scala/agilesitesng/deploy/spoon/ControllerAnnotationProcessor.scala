package agilesitesng.deploy.spoon

import agilesites.annotations.{Controller, CSElement}
import agilesitesng.deploy.model.{Spooler, SpoonModel, Uid}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.declaration.CtClass

/**
  * Created by msciab on 06/08/15.
  */
class ControllerAnnotationProcessor
  extends AbstractAnnotationProcessor[Controller, CtClass[_]]
  with SpoonUtils {

  def process(a: Controller, cl: CtClass[_]) {

    val classname = cl.getQualifiedName
    val key = s"Controller.$classname"

    Spooler.insert(50, key,
      SpoonModel.Controller(
        id = Uid.generate(key),
        name = classname,
        description = s"Controller ${classname}",
        classname = classname,
        file = class2file(classname)))
  }
}

