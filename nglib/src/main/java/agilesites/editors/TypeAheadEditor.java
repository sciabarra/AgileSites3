package agilesites.editors;

/**
 * Created by jelerak on 3/11/2015.
 */
public class TypeAheadEditor extends AbstractAttributeEditor {

    protected int maxValues;
    protected int pagesize;

    public TypeAheadEditor maxValues(int maxValues) {
        this.maxValues = maxValues;
        return this;
    }
    public TypeAheadEditor pageSize(int pageSize) {
        this.pagesize = pageSize;
        return this;
    }

    public String toXml() {
        StringBuilder builder = new StringBuilder();
        builder.append("<TYPEAHEAD " + getConfig() + "/>");
        return builder.toString();
    }

    public String getConfig() {
        StringBuilder stringBuilder =  new StringBuilder();
        if (pagesize > 0) {
            stringBuilder.append(" PAGESIZE=\"").append(pagesize).append("\"");
        }

        if (maxValues > 0) {
            stringBuilder.append(" MAXVALUES=\"").append(maxValues).append("\"");
        }
        return stringBuilder.toString();
    }

}
