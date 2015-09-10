package ngdemo;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.annotations.FlexFamily;
import agilesites.api.AgileSite;

/**
 * Declaring the site with his types
 */
@FlexFamily(
        flexAttribute = "NgAttribute",
        flexParentDefinition = "NgParentDefinition",
        flexContentDefinition = "NgContentDefinition",
        flexFilter = "NgFilter",
        flexContent = "NgContent",
        flexParent = "NgParent"
)
@Site(enabledTypes = {"NgAttribute",
        "NgParentDefinition",
        "NgContentDefinition",
        "NgContent",
        "NgParent",
        "PageAttribute",
        "PageDefinition",
        "Page"})
public class NgDemo extends AgileSite {

    @AttributeEditor
    private String NgRichTextEditor = "<CKEDITOR/>";

}
