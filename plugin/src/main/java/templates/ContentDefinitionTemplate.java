package templates;

import agilesitesng.deploy.model.SpoonModel;
import spoon.reflect.declaration.CtElement;
import spoon.reflect.declaration.CtType;
import spoon.template.Local;
import spoon.template.Parameter;
import spoon.template.Substitution;
import spoon.template.Template;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

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

    public List<String> getAttributes() {
        ArrayList<String> temp = new ArrayList<String>();
        Collections.addAll(temp, attributes.split("|"));
        return temp;
    }

    @Override
    @Local
    public CtElement apply(CtType target) {
        Substitution.insertAllMethods(target, this);
        return target;
    }
}
