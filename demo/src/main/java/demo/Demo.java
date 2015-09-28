package demo;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.annotations.FlexFamily;
import agilesites.api.AgileSite;
import agilesites.editors.RichTextEditor;
import agilesites.editors.UploaderEditor;

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
        "DmContent:F",
        "DmParent:F",
        "PageAttribute",
        "PageDefinition",
        "Page:F"})
public class Demo extends AgileSite {

    @AttributeEditor
    private String DmRichTextEditor = "<CKEDITOR/>";

    @AttributeEditor
    private String DmUploaderEditor = "<UPLOADER FILETYPES=\"jpg;jpeg;png\" />";
}
