package demo.model.dmparent;

import agilesites.annotations.*;
import demo.model.DmParent;

@FindStartMenu("Find Gallery")
@StartMenu("New Gallery")
@ParentDefinition
@Parent("DmGallery")
public class DmGallery extends DmParent {

    @Attribute
    @Required
    private String categoryString;

    @Attribute
    private String testAttribute;

    public String getCategoryString() {
        return categoryString;
    }
}
