
package boot;

import agilesites.annotations.AttributeEditor;
import agilesites.annotations.Site;
import agilesites.annotations.FlexFamily;
import agilesites.api.AgileSite;

@FlexFamily(
       flexAttribute = "Boot_A",
       flexParentDefinition = "Boot_PD",
       flexContentDefinition = "Boot_CD",
       flexFilter = "Boot_F",
       flexContent = "Boot_C",
       flexParent = "Boot_P")
@Site(enabledTypes = {"Boot_A",
       "Boot_PD",
       "Boot_CD",
       "Boot_C:F",
       "Boot_P:F",
       "WCS_Controller",
       "Template",
       "CSElement",
       "SiteEntry",
       "PageAttribute",
       "PageDefinition",
       "Page:F"})
public class Boot extends AgileSite {

   @AttributeEditor
   private String BootRichTextEditor = "<CKEDITOR/>";

}
      