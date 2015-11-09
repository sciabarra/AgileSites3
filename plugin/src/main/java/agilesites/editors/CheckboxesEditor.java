package agilesites.editors;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jelerak on 3/11/2015.
 */
public class CheckboxesEditor extends AbstractAttributeEditor {

    private static final String CHECKBOXES_END = "</CHECKBOXES>";
    private static final String CHECKBOXES_ITEM_START = "<ITEM>";
    private static final String CHECKBOXES_ITEM_END = "</ITEM>";
    private static final String QUERYASSET_START = "<QUERYASSETNAME>";
    private static final String QUERYASSET_END = "</QUERYASSETNAME>";

    protected List<String> itemList = new ArrayList<String>();
    protected String layout = LayoutEnum.VERTICAL.toString();

    protected String queryAssetName;


    public String toXml() {
        StringBuilder builder = new StringBuilder();
        builder.append("<CHECKBOXES LAYOUT= '").append(layout).append("'>");
        if (queryAssetName != null && queryAssetName.length() > 0){
            builder.append(QUERYASSET_START).append(queryAssetName).append(QUERYASSET_END);
        } else {
            for (String item: itemList){
                builder.append(CHECKBOXES_ITEM_START).append(item).append(CHECKBOXES_ITEM_END);
            }
        }
        builder.append(CHECKBOXES_END);
        return builder.toString();
    }

    public CheckboxesEditor withItem(String item) {
        itemList.add(item);
        return this;
    }

    public CheckboxesEditor withLayout(LayoutEnum layout) {
        this.layout = layout.toString();
        return this;
    }

    public CheckboxesEditor withQueryAssetName(String queryAssetName) {
        this.queryAssetName = queryAssetName;
        return this;
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
