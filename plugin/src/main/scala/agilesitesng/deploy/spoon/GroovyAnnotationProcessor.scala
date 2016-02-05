package agilesitesng.deploy.spoon

import agilesites.annotations.{MultipleStartMenu, Groovy, FlexFamily}
import spoon.processing.AbstractAnnotationProcessor
import spoon.reflect.code.{CtLocalVariable, CtCodeSnippetStatement, CtStatement}
import spoon.reflect.declaration.{CtMethod, CtClass}

/**
  * Created by msciab on 25/01/16.
  */
class GroovyAnnotationProcessor extends AbstractAnnotationProcessor[Groovy, CtLocalVariable[_]] {
  def process(an: Groovy, lv: CtLocalVariable[_]) {
    val snippet = getFactory().Core().createCodeSnippetStatement()
    snippet.setValue(an.value())
    lv.replace(snippet)
  }
}