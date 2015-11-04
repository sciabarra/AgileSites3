package demo.model.dmcontent;

import agilesites.annotations.*;
import demo.model.DmContent;

@NewStartMenu(value = "Text Block")
@FindStartMenu("Text Block")
@ContentDefinition(flexAttribute = "DemoAttribute",
        flexContent = "DemoContentDefinition",
        flexParent = "DemoParentDefinition")
@Parents("DmFolder")
public class DmTextBlock extends DmContent {

    @Attribute
    private String header;

    @Attribute(editor = "DmRichTextEditor")
    private String body;

}
