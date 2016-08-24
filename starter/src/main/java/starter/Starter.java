package starter;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.api.AgileSite;

@Site(enabledTypes = {
        "AttrTypes",
        "Template",
        "CSElement",
        "SiteEntry",
        "PageAttribute",
        "PageDefinition",
        "Page:F"})
public class Starter extends AgileSite {

    @AttributeEditor
    private String stRichTextEditor = "<CKEDITOR/>";

    @AttributeEditor
    private String stUploaderEditor = "<UPLOADER FILETYPES=\"jpg;jpeg;png\" />";
}
