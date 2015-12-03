package boot;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.annotations.FlexFamily;
import agilesites.api.AgileSite;

/**
 * Declaring the site with his types
 */
@FlexFamily(
        flexAttribute = "BootAttribute",
        flexParentDefinition = "BootParentDefinition",
        flexContentDefinition = "BootContentDefinition",
        flexFilter = "BootFilter",
        flexContent = "BootContent",
        flexParent = "BootParent"
)
@Site(enabledTypes = {"BootAttribute",
        "BootParentDefinition",
        "BootContentDefinition",
        "BootContent:F",
        "BootParent:F",
        "Template",
        "CSElement",
        "SiteEntry",
        "WCS_Controller",
        "PageAttribute",
        "PageDefinition",
        "Page:F"})
public class Boot extends AgileSite {

    @AttributeEditor
    private String BootRichTextEditor = "<CKEDITOR/>";

    @AttributeEditor
    private String BootUploaderEditor = "<UPLOADER FILETYPES=\"jpg;jpeg;png\" />";
}
