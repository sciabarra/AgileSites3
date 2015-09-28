package agilesites.editors;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jelerak on 3/11/2015.
 */
public class PullDownEditor extends AbstractAttributeEditor {

    private static final String PULLDOWN_START = "<PULLDOWN>";
    private static final String PULLDOWN_END = "</PULLDOWN>";
    private static final String PULLDOWN_ITEM_START = "<ITEM>";
    private static final String PULLDOWN_ITEM_END = "</ITEM>";
    private static final String QUERYASSET_START = "<QUERYASSETNAME>";
    private static final String QUERYASSET_END = "</QUERYASSETNAME>";

    protected List<String> itemList = new ArrayList<String>();

    protected String queryAssetName;

    public PullDownEditor withItem(String item) {
        this.itemList.add(item);
        return this;
    }

    public PullDownEditor withQueryAssetName(String queryAssetName) {
        this.queryAssetName = queryAssetName;
        return this;
    }

    public String toXml() {
        StringBuilder builder = new StringBuilder();
        builder.append(PULLDOWN_START);
        if (queryAssetName != null && queryAssetName.length() > 0){
            builder.append(QUERYASSET_START).append(queryAssetName).append(QUERYASSET_END);
        } else {
            for (String item: itemList){
                builder.append(PULLDOWN_ITEM_START).append(item).append(PULLDOWN_ITEM_END);
            }
        }
        builder.append(PULLDOWN_END);
        return builder.toString();
    }

}
