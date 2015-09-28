package agilesites.editors;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jelerak on 3/11/2015.
 */
public class RadioButtonsEditor extends AbstractAttributeEditor {

    private static final String RADIOBUTTON_END = "</RADIOBUTTONS>";
    private static final String RADIOBUTTON_ITEM_START = "<ITEM>";
    private static final String RADIOBUTTON_ITEM_END = "</ITEM>";
    private static final String QUERYASSET_START = "<QUERYASSETNAME>";
    private static final String QUERYASSET_END = "</QUERYASSETNAME>";

    protected List<String> itemList = new ArrayList<String>();
    protected String layout = LayoutEnum.VERTICAL.toString();

    protected String queryAssetName;

    public RadioButtonsEditor withItem(String item) {
        this.itemList.add(item);
        return this;
    }

    public RadioButtonsEditor withLayout(LayoutEnum layout) {
        this.layout = layout.toString();
        return this;
    }

    public RadioButtonsEditor withQueryAssetName(String queryAssetName) {
        this.queryAssetName = queryAssetName;
        return this;
    }

    public String toXml() {
        StringBuilder builder = new StringBuilder();
        builder.append("<RADIOBUTTONS LAYOUT= '").append(layout).append("'>");
        if (queryAssetName != null && queryAssetName.length() > 0){
            builder.append(QUERYASSET_START).append(queryAssetName).append(QUERYASSET_END);
        } else {
            for (String item: itemList){
                builder.append(RADIOBUTTON_ITEM_START).append(item).append(RADIOBUTTON_ITEM_END);
            }
        }
        builder.append(RADIOBUTTON_END);
        return builder.toString();
    }

    public enum LayoutEnum {
        HORIZONTAL("HORIZONTAL"),
        VERTICAL("VERTICAL");

        private String layout;

        LayoutEnum(String layout) {
            this.layout = layout;
        }

        public String toString() {
            return layout;
        }
    }

}
