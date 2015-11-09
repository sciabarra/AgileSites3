package agilesites.editors;

/**
 * Created by jelerak on 3/11/2015.
 */
public class PickAssetEditor extends AbstractAttributeEditor {

    private static final String PICKASSET_START = "<PICKASSET>";
    private static final String PICKASSET_END = "</PICKASSET>";

    protected int maxValues;

    public PickAssetEditor withMaxValues(int maxValues) {
        this.maxValues = maxValues;
        return this;
    }

    public String toXml() {
        StringBuilder builder = new StringBuilder();
        builder.append(PICKASSET_START);
        builder.append(PICKASSET_END);
        return builder.toString();
    }

}
