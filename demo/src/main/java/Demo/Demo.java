package demo;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.annotations.FlexFamily;
import agilesites.api.AgileSite;

/**
 * Declaring the site with his types
 */
@FlexFamily(
        flexAttribute = "DemoAttribute",
        flexParentDefinition = "DemoParentDefinition",
        flexContentDefinition = "DemoContentDefinition",
        flexFilter = "DemoFilter",
        flexContent = "DmContent",
        flexParent = "DmParent"
)
@Site(enabledTypes = {"DemoAttribute",
        "DemoParentDefinition",
        "DemoContentDefinition",
        "DmContent",
        "DmParent"})
public class Demo extends AgileSite {

    @AttributeEditor
    private String DmRichTextEditor = "<CKEDITOR/>";

}
