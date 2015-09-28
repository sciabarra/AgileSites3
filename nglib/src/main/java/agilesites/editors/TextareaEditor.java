package agilesites.editors;

/**
 * Created by jelerak on 3/11/2015.
 */
public class TextareaEditor extends AbstractAttributeEditor {

    protected int width;
    protected int height;
    protected boolean resize;
    protected String wrapStyle;


    public TextareaEditor withResize(boolean resize) {
        this.resize = resize;
        return this;
    }

    public TextareaEditor withWrapStyle(String wrapStyle) {
        this.wrapStyle = wrapStyle;
        return this;
    }

    public TextareaEditor withWidth(int width) {
        this.width = width;
        return this;
    }

    public TextareaEditor withHeight(int height) {
        this.height = height;
        return this;
    }

    public String toXml() {
        StringBuilder builder = new StringBuilder();
        builder.append("<TEXTAREA " + getConfig() + "/>");
        return builder.toString();
    }

    public String getConfig() {
        StringBuilder stringBuilder =  new StringBuilder();
        stringBuilder.append(" WRAPSTYLE=\"").append(wrapStyle).append("\"")
                .append(" WIDTH=\"").append(width).append("\"")
                .append(" HEIGHT=\"").append(height).append("\"")
                .append(" RESIZE=\"").append(resize).append("\"");

        return stringBuilder.toString();
    }

}
