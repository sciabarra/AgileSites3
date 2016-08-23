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
class CSElementClassAnnotationProcessor
  extends AbstractAnnotationProcessor[CSElement, CtClass[_]]
    with SpoonUtils {

  def process(a: CSElement, cl: CtClass[_]) {

    val name = orEmpty(a.name(), cl.getSimpleName)
    val key = s"CSElement.$name"
    val className = cl.getQualifiedName
    val filename = s"jsp/${sys.props("spoon.site")}/${name}.jsp"

    Spooler.insert(50, key,
      SpoonModel.CSElement(
        id = Uid.generate(key),
        name = name,
        description = s"CSElement for ${name}",
        file = writeFileOutdir(filename,
          JspUtils.streamer(className))))
  }

}
