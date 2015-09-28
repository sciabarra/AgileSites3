package agilesites.editors;

/**
 * Created by jelerak on 3/11/2015.
 */
public class UploaderEditor extends AbstractAttributeEditor {

    protected int maxValues;
    protected String maxFileSize;
    protected String fileTypes;
    protected int minWidth;
    protected int maxWidth;
    protected int minHeight;
    protected int maxHeight;

    public UploaderEditor withMaxValues(int maxValues) {
        this.maxValues = maxValues;
        return this;
    }

    public UploaderEditor withMaxFileSize(String maxFileSize) {
        this.maxFileSize = maxFileSize;
        return this;
    }

    public UploaderEditor withMinWidth(int minWidth) {
        this.minWidth = minWidth;
        return this;
    }

    public UploaderEditor withMaxWidth(int maxWidth) {
        this.maxWidth = maxWidth;
        return this;
    }

    public UploaderEditor withMinHeight(int minHeight) {
        this.minHeight = minHeight;
        return this;
    }

    public UploaderEditor withMaxHeight(int maxHeight) {
        this.maxHeight = maxHeight;
        return this;
    }

    public UploaderEditor withFileTypes(String... fileTypes) {
        StringBuilder sb = new StringBuilder();
        for (String fileType : fileTypes) {
            sb.append(fileType).append(";");
        }
        if (sb.length() > 0) {
            sb.deleteCharAt(sb.length() -1);
        }
        else {
            sb.append("*.*");
        }
        this.fileTypes = sb.toString();
        return this;
    }

    public String toXml() {
        StringBuilder builder = new StringBuilder();
        builder.append("<UPLOADER " + getConfigElements() + "/>");
        return builder.toString();
    }

    public String getConfigElements() {
        StringBuilder stringBuilder =  new StringBuilder();
        stringBuilder.append(" MAXFILESIZE=\"").append(maxFileSize).append("\"")
                .append(" FILETYPES=\"").append(fileTypes).append("\"")
                .append(" MINWIDTH=\"").append(minWidth).append("\"")
                .append(" MAXWIDTH=\"").append(maxWidth).append("\"")
                .append(" MINHEIGHT=\"").append(minHeight).append("\"")
                .append(" MAXHEIGHT=\"").append(maxHeight).append("\"");

        if (maxValues > 0) {
            stringBuilder.append(" MAXVALUES=\"").append(maxValues).append("\"");
        }


        return stringBuilder.toString();
    }
}
