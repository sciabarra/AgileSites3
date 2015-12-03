package bs;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.annotations.FlexFamily;
import agilesites.api.AgileSite;

/**
 * Declaring the site with his types
 */
@FlexFamily(
        flexAttribute = "BsAttribute",
        flexParentDefinition = "BsParentDefinition",
        flexContentDefinition = "BsContentDefinition",
        flexFilter = "BsFilter",
        flexContent = "BsContent",
        flexParent = "BsParent"
)
@Site(enabledTypes = {"BsAttribute",
        "BsParentDefinition",
        "BsContentDefinition",
        "BsContent:F",
        "BsParent:F",
        "Template",
        "CSElement",
        "SiteEntry",
        "Controller",
        "PageAttribute",
        "PageDefinition",
        "Page:F"})
public class Bs extends AgileSite {

    @AttributeEditor
    private String BsRichTextEditor = "<CKEDITOR/>";

    @AttributeEditor
    private String BsUploaderEditor = "<UPLOADER FILETYPES=\"jpg;jpeg;png\" />";
}
