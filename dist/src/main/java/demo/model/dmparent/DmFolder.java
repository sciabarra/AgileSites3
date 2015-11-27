package demo.model.dmparent;

import agilesites.annotations.*;
import demo.model.DmParent;

@FindStartMenu("Find Folder")
@NewStartMenu("New Folder")
@ParentDefinition(flexAttribute = "DemoAttribute",
        flexParent = "DemoParentDefinition")
@Parents("DmFolder")
public class DmFolder extends DmParent {

    @Attribute
    @Required
    private String categoryString;

}
