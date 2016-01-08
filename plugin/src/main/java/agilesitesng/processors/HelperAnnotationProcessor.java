package agilesitesng.processors;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.ParentDefinition;
import org.kohsuke.MetaInfServices;
//import org.kohsuke.MetaInfServices;

import javax.annotation.processing.*;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.ElementKind;
import javax.lang.model.element.TypeElement;
import javax.lang.model.element.VariableElement;
import javax.lang.model.util.Elements;
import javax.lang.model.util.Types;
import javax.tools.Diagnostic;
import java.io.IOException;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Created by jelerak on 04/12/2015.
 */
@MetaInfServices(Processor.class)
public class HelperAnnotationProcessor extends AbstractProcessor {

    private Types typeUtils;
    private Elements elementUtils;
    private Filer filer;
    private Messager messager;
    //private boolean isRoundOne = false;

    @Override
    public synchronized void init(ProcessingEnvironment processingEnv) {
        super.init(processingEnv);
        typeUtils = processingEnv.getTypeUtils();
        elementUtils = processingEnv.getElementUtils();
        filer = processingEnv.getFiler();
        messager = processingEnv.getMessager();
    }

    @Override
    public Set<String> getSupportedAnnotationTypes() {
        Set<String> annotations = new LinkedHashSet<>();
        annotations.add(ContentDefinition.class.getCanonicalName());
        annotations.add(ParentDefinition.class.getCanonicalName());
        return annotations;
    }

    @Override
    public SourceVersion getSupportedSourceVersion() {
        return SourceVersion.latestSupported();
    }


    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {

        try {

            // Scan classes
            for (Element annotatedElement : roundEnv.getElementsAnnotatedWith(ContentDefinition.class)) {

                // Check if a class has been annotated with @ContentDefinition
                if (annotatedElement.getKind() != ElementKind.CLASS) {
                    error(annotatedElement, "Only classes can be annotated with @%s", ContentDefinition.class.getSimpleName());
                }

                // We can cast it, because we know that it of ElementKind.CLASS
                TypeElement typeElement = (TypeElement) annotatedElement;

                DefinitionHelperClass definitionHelperClass = new DefinitionHelperClass(typeElement.getQualifiedName().toString(), typeElement.getSuperclass());
                for (Element element : typeElement.getEnclosedElements()) {
                    if(element.getKind().equals(ElementKind.FIELD)) {
                        Attribute[] attributes = element.getAnnotationsByType(Attribute.class);
                        if (attributes.length > 0) {
                            VariableElement annotatedField = (VariableElement) element;
                            definitionHelperClass.addAttribute(annotatedField.getSimpleName().toString(), annotatedField.asType());
                        }
                    }
                }

                definitionHelperClass.generateCode(elementUtils, filer);
            }
            // Scan classes
            for (Element annotatedElement : roundEnv.getElementsAnnotatedWith(ParentDefinition.class)) {

                // Check if a class has been annotated with @ParentDefinition
                if (annotatedElement.getKind() != ElementKind.CLASS) {
                    error(annotatedElement, "Only classes can be annotated with @%s", ParentDefinition.class.getSimpleName());
                }

                // We can cast it, because we know that it of ElementKind.CLASS
                TypeElement typeElement = (TypeElement) annotatedElement;
            }

            // Generate code
        } catch (IOException e) {
            e.printStackTrace();

        }

        return true;
    }

    private void error(Element e, String msg, Object... args) {
        messager.printMessage(
                Diagnostic.Kind.ERROR,
                String.format(msg, args),
                e);
    }

}
