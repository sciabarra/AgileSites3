package templates;

import spoon.reflect.declaration.CtElement;
import spoon.reflect.declaration.CtType;
import spoon.template.Local;
import spoon.template.Parameter;
import spoon.template.Substitution;
import spoon.template.Template;

/**
 * Created by jelerak on 15/10/2015.
 */
public class ContentDefinitionTemplate implements Template {

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
