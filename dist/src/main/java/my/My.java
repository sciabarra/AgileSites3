package my;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.annotations.FlexFamily;
import agilesites.api.AgileSite;
import agilesites.editors.RichTextEditor;
import agilesites.editors.UploaderEditor;

@Site(enabledTypes = {
        "Template",
        "CSElement",
        "SiteEntry",
        "Controller",
        "PageAttribute",
        "PageDefinition",
        "Page:F"})
public class My extends AgileSite {

}