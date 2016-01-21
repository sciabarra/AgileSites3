package boot;

import agilesites.annotations.*;
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
        flexParent = "BootParent",
        additionalFlexParents = {"BootGallery"},
        additionalFlexTypes = {
                @FlexType(name = "BootImage", parentType = "BootGallery"),
                @FlexType(name = "BootContainer", parentType = "BootParent")
        }
)

@Site(enabledTypes = {"BootAttribute",
        "BootParentDefinition",
        "BootContentDefinition",
        "BootContent:F",
        "BootImage:F",
        "BootContainer:F",
        "BootParent:F",
        "BootGallery:F",
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
