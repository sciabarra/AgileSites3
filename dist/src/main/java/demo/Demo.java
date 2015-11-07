package demo;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.annotations.FlexFamily;
import agilesites.api.AgileSite;
import agilesites.editors.RichTextEditor;
import agilesites.editors.UploaderEditor;

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
        "Template",
        "CSElement",
        "SiteEntry",
        "Controller",
        "PageAttribute",
        "PageDefinition",
        "Page:F"})
public class Demo extends AgileSite {

    @AttributeEditor
    private String DmRichTextEditor = "<CKEDITOR/>";

    @AttributeEditor
    private String DmUploaderEditor = "<UPLOADER FILETYPES=\"jpg;jpeg;png\" />";
}