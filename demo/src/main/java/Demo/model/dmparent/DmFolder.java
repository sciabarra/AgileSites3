package demo.model.dmparent;

import agilesites.annotations.*;
import demo.model.DmParent;

@FindStartMenu("Find Folder")
@StartMenu("New Folder")
@ParentDefinition
@Parent("DmFolder")
public class DmFolder extends DmParent {

    @Attribute
    @Required
    private String categoryString;

    private String testField;

    public String getCategoryString() {
        return categoryString;
    }
}
