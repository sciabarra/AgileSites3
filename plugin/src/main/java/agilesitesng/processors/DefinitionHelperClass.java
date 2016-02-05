package agilesitesng.processors;

import com.squareup.javapoet.*;
import org.apache.commons.lang.StringUtils;
import org.apache.lucene.analysis.tokenattributes.TypeAttribute;

import javax.annotation.processing.Filer;
import javax.lang.model.element.Modifier;
import javax.lang.model.element.PackageElement;
import javax.lang.model.element.TypeElement;
import javax.lang.model.type.ArrayType;
import javax.lang.model.type.DeclaredType;
import javax.lang.model.type.TypeKind;
import javax.lang.model.type.TypeMirror;
import javax.lang.model.util.Elements;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by jelerak on 04/12/2015.
 */
public class DefinitionHelperClass {

    private static final String SUFFIX = "Helper";

    private TypeMirror superclassName;
    private String qualifiedClassName;
    private List<HelperAttribute> attributes = new ArrayList<>();

    public void addAttribute(String name, TypeMirror type) {
        attributes.add(new HelperAttribute(name, type));
    }

    public DefinitionHelperClass(String qualifiedClassName, TypeMirror superclassName) {
        this.qualifiedClassName = qualifiedClassName;
        this.superclassName = superclassName;
    }

    public List<HelperAttribute> getAttributes() {
        return attributes;
    }

    private class HelperAttribute {
        private String name;
        private TypeMirror type;

        public HelperAttribute(String name, TypeMirror type) {
            this.name = name;
            this.type = type;
        }

        public String getName() {
            return name;
        }

        public TypeMirror getType() {
            return type;
        }
    }

    public void generateCode(Elements elementUtils, Filer filer) throws IOException {
        TypeElement className = elementUtils.getTypeElement(qualifiedClassName);
        String factoryClassName = className.getSimpleName() + SUFFIX;
        PackageElement pkg = elementUtils.getPackageOf(className);
        String packageName = pkg.isUnnamed() ? null : pkg.getQualifiedName().toString();
        List<MethodSpec> methods = new ArrayList<>();

        TypeSpec.Builder typeSpecBuilder = TypeSpec.classBuilder(factoryClassName).addModifiers(Modifier.PUBLIC).superclass(TypeName.get(DefinitionHelper.class)).addOriginatingElement(className);

        //typeSpecBuilder.addSuperinterface(DefinitionHelper.class);

        MethodSpec constructor = MethodSpec.constructorBuilder()
                .addModifiers(Modifier.PUBLIC)
                .addParameter(String.class, "name")
                .addStatement("this.$N = $N", "name", "name")
                .build();
        typeSpecBuilder.addMethod(constructor);

        FieldSpec nameField = FieldSpec.builder(TypeName.get(String.class), "name", Modifier.PRIVATE).build();

        typeSpecBuilder.addField(nameField);

        MethodSpec nameGetter = MethodSpec.methodBuilder("getName").addModifiers(Modifier.PUBLIC).addStatement("return name").returns(String.class).build();

        typeSpecBuilder.addMethod(nameGetter);

        for (HelperAttribute attribute : attributes) {
            methods.addAll(getMethodsForAttribute(attribute));
        }


        TypeSpec typeSpec = typeSpecBuilder.addMethods(methods).build();

        // Write file
        JavaFile.builder(packageName, typeSpec).build().writeTo(filer);

    }

    private List<MethodSpec> getMethodsForAttribute(HelperAttribute attribute) {
        List<MethodSpec> methods = new ArrayList<>();


        if (attribute.getType().getKind().equals(TypeKind.DECLARED)) {
            methods.addAll(generateSimpleAccessors(attribute));
        }
        else if (attribute.getType().getKind().equals(TypeKind.ARRAY)) {
            methods.addAll(generateIndexedAccessors(attribute));
        }
        return methods;
    }

    private Collection<? extends MethodSpec> generateIndexedAccessors(HelperAttribute attribute) {
        List<MethodSpec> methods = new ArrayList<>();
        System.out.println("attribute type: " + attribute.getType().toString());
        boolean generateMethods = true;

        ArrayType attributeType = (ArrayType) attribute.getType();
        return methods;
    }

    private List<MethodSpec> generateSimpleAccessors(HelperAttribute attribute ) {
        List<MethodSpec> methods = new ArrayList<>();
        System.out.println("attribute type: " + attribute.getType().toString());
        boolean generateMethods = true;

        DeclaredType attributeType = (DeclaredType) attribute.getType();
        String getMethodName = "get" + StringUtils.capitalize(attribute.getName());
        String editMethodName = "edit" + StringUtils.capitalize(attribute.getName());

        TypeName returnType = TypeName.get(String.class);

        MethodSpec.Builder getMethod = MethodSpec.methodBuilder(getMethodName)
                .addModifiers(Modifier.PUBLIC)
                .returns(returnType);
        MethodSpec.Builder editMethod = MethodSpec.methodBuilder(editMethodName)
                .addModifiers(Modifier.PUBLIC)
                .returns(returnType);
        switch (attributeType.asElement().toString()) {
            case "java.lang.String":
                getMethod.addStatement(String.format("return getString(getName(),\"%s\")", attribute.getName()));
                editMethod.addStatement(String.format("return editString(getName(),\"%s\")", attribute.getName()));
                break;
            case "java.util.Date":
                getMethod.addParameter(String.class,"format");
                getMethod.addStatement(String.format("return getDate(getName(),\"%s\",format)", attribute.getName()));
                editMethod.addParameter(String.class,"format");
                editMethod.addStatement(String.format("return editDate(getName(),\"%s\",format)", attribute.getName()));
                break;
            case "agilesitesng.api.BlobAttribute":
                getMethod.addStatement(String.format("return getBlobUrl(getName(),\"%s\")", attribute.getName()));
                editMethod.addStatement(String.format("return getBlobUrl(getName(),\"%s\")", attribute.getName()));
                break;
            case "agilesitesng.api.AssetAttribute":
                getMethod.addStatement(String.format("return getAsset(getName(),\"%s\")", attribute.getName()));
                editMethod.addStatement(String.format("return getAsset(getName(),\"%s\")", attribute.getName()));
                break;
        }
        methods.add(getMethod.build());
        methods.add(editMethod.build());
        return methods;
    }
}
