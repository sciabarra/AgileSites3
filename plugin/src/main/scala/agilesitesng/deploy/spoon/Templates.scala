package agilesitesng.deploy.spoon

import java.io.File

/**
 * Created by msciab on 27/11/15.
 */
object Templates extends SpoonUtils {

  def extractTemplates(tgt: File): Unit = {
    tgt.mkdirs
    val cdt = new File(tgt, "ContentDefinitionTemplate.java")
    //if (!cdt.exists)
    writeFile(cdt, """package templates;

import agilesitesng.api.ASAsset;
import spoon.reflect.declaration.CtElement;
import spoon.reflect.declaration.CtType;
import spoon.template.Local;
import spoon.template.Parameter;
import spoon.template.Substitution;
import spoon.template.Template;

/**
 * Created by jelerak on 15/10/2015.
 */
public class ContentDefinitionTemplate extends ASAsset implements Template {

    @Parameter
    String attributes;

    @Local
    public ContentDefinitionTemplate(String attributes) {
        this.attributes = attributes;
    }

    public String readAttributes() {
        return attributes;
    }

    @Override
    @Local
    public CtElement apply(CtType target) {
        Substitution.insertAllMethods(target, this);
        return target;
    }

}
      """)

    val fat = new File(tgt, "FieldAccessTemplate.java")
    //if (!fat.exists)
    writeFile(fat, """package templates;

import spoon.reflect.declaration.CtElement;
import spoon.reflect.declaration.CtType;
import spoon.reflect.reference.CtTypeReference;
import spoon.template.Local;
import spoon.template.Parameter;
import spoon.template.Template;

/**
 * This template defines the needed template code for matching and/or generating
 * field accesses through getters and setters:
 */
public class FieldAccessTemplate<_FieldType_> implements Template {

    @Parameter
    CtTypeReference<?> _FieldType_;

    @Parameter("_field_")
    String __field_;

    @Parameter
    String _Field_;


    @SuppressWarnings("unchecked")
    @Local
    public FieldAccessTemplate(CtTypeReference<?> type, String field) {
        _FieldType_ = type;
        __field_ = field;
        char[] chars = field.toCharArray();
        chars[0] = Character.toUpperCase(chars[0]);
        _Field_ = new String(chars);
    }

    @Local
    _FieldType_ _field_;

    /**
     * This template code defines the setter of a field {@link #_field_}. Note
     * the template parameter {@link #_FieldType_} that contains the field's
     * type (also defined as a type parameter) and the {@link #_Field_} that
     * contains the name of the field with the first letter uppercased.
     */
    public void set_Field_(_FieldType_ _field_) {
        this._field_ = _field_;
    }

    /**
     * This template code defines the getter of a field {@link #_field_}. Note
     * the template parameter {@link #_FieldType_} that contains the field's
     * type (also defined as a type parameter) and the {@link #_Field_} that
     * contains the name of the field with the first letter uppercased.
     */
    public _FieldType_ get_Field_() {
        return _field_;
    }

    @Override
    public CtElement apply(CtType ctType) {
        return null;
    }
}
                   """)
  }
}
