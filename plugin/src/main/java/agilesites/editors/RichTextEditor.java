package agilesites.editors;

/**
 * Created by jelerak on 3/11/2015.
 */
public class RichTextEditor extends AbstractAttributeEditor  {

    //Default Values
    private String widthValue = "400";
    private String heightValue = "600";
    private String allowedAssetTypesValue;
    private String toolbarValue;
    private String configValue;
    private String configObjValue;

    public RichTextEditor() {
    }

    public String toXml() {
        return "<CKEDITOR"+ getConfig()+ "/>";
    }

    public String getConfig() {
        StringBuilder stringBuilder =  new StringBuilder();
        stringBuilder.append(" WIDTH=\"").append(widthValue).append("\"")
                .append(" HEIGHT=\"").append(heightValue).append("\"");

        if (allowedAssetTypesValue != null) {
            stringBuilder.append(" ALLOWEDASSETTYPES=\"").append(allowedAssetTypesValue).append("\"");
        }
        if (toolbarValue != null) {
            stringBuilder.append(" TOOLBAR=\"").append(toolbarValue).append("\"");
        }
        if (configValue != null) {
            stringBuilder.append(" CONFIG=\"").append(configValue).append("\"");
        }
        if (configObjValue != null) {
            stringBuilder.append(" CONFIGOBJ=\"").append(configObjValue).append("\"");
        }

        return stringBuilder.toString();
    }

    public RichTextEditor withWidthValue(int widthValue) {
        this.widthValue = ""+widthValue;
        return this;
    }

    public RichTextEditor withHeightValue(int heightValue) {
        this.heightValue = ""+heightValue;
        return this;
    }

    public RichTextEditor withtAllowedAssetTypesValue(String allowedAssetTypesValue) {
        this.allowedAssetTypesValue = allowedAssetTypesValue;
        return this;
    }

    public RichTextEditor withToolbarValue(String toolbarValue) {
        this.toolbarValue = toolbarValue;
        return this;
    }

    public RichTextEditor withConfigValue(String configValue) {
        this.configValue = configValue;
        return this;
    }

    public RichTextEditor withConfigObjValue(String configObjValue) {
        this.configObjValue = configObjValue;
        return this;
    }

    public enum YesNoEnum {
        YES("YES"),
        NO("NO");

        private String value;

        private YesNoEnum(String value) {
            this.value = value;
        }

        public String toString() {
            return value;
        }
    }

}
