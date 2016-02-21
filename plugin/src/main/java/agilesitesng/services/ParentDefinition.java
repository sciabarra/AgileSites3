package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.common.AssetAccessException;
import com.fatwire.assetapi.data.*;
import com.fatwire.assetapi.def.AttributeTypeEnum;
import com.fatwire.assetapi.query.SimpleQuery;
import com.openmarket.xcelerate.asset.AssetIdImpl;
import com.openmarket.xcelerate.asset.AttributeDefImpl;

import java.util.*;

public class ParentDefinition extends Asset {

    String attributeTable;
    List<Long> attributeIds = new LinkedList<Long>();
    List<Boolean> isRequireds = new LinkedList<Boolean>();
    List<Long> parentIds = new LinkedList<Long>();

    public ParentDefinition(ICS ics) {
        super(ics.GetVar("c"), ics);
        attributeTable = ics.GetVar("attributeType");
        String[] attrs = Utils.splitOnPipe(ics.GetVar("attributes"));
        String[] parents = Utils.splitOnPipe(ics.GetVar("parents"));
        for (String attr : attrs) {
            String[] attrid = attr.split(":");
            attributeIds.add(Long.valueOf(attrid[1]));
            isRequireds.add(Boolean.valueOf(attrid[0]));
        }
        for (String parent : parents) {
            parentIds.add(Long.valueOf(parent));
        }

    }

    protected AttributeDataImpl attrData(String name, AttributeTypeEnum type, Object value) {
        return new AttributeDataImpl(new AttributeDefImpl(name, type), name, type, value);
    }

    protected AttributeDataImpl attrData(String name, boolean isRequired) {
        return attrData(name, AttributeTypeEnum.STRING, isRequired ? "true": "false");
    }


    @Override
    public void setData(MutableAssetData ad) {
        int i = 0;
        for (Long id : attributeIds) {
            if (id > 0) {
                boolean req = isRequireds.get(i);
                Map<?, ?> map = attributeMap(id, req, i + 1);
                ad.getAttributeData("Attributes").addData(map);
            } else {
                System.out.println("skipping attribute " + id);
            }
            i++;
        }

        for (Long id : parentIds) {
            //TODO manage required and multiple parents
            Map<?, ?> map = groupMap(id, false, false);
            ad.getAttributeData("Groups").addData(map);
            i++;
        }
    }

    protected Map<String, AttributeData> attributeMap(long id, boolean isRequired, int order) {

        AssetId aid = new AssetIdImpl(attributeTable, id);
        Map<String, AttributeData> map = new HashMap<String, AttributeData>();
        AttributeDataImpl ordinal = new AttributeDataImpl(new AttributeDefImpl(
                "ordinal", AttributeTypeEnum.INT), "ordinal",
                AttributeTypeEnum.INT, order);
        map.put("ordinal", ordinal);
        AttributeDataImpl required = new AttributeDataImpl(
                new AttributeDefImpl("required", AttributeTypeEnum.STRING),
                "required", AttributeTypeEnum.STRING, isRequired ? "true"
                : "false");
        map.put("required", required);
        AttributeDataImpl asset = new AttributeDataImpl(new AttributeDefImpl(
                "assetid", AttributeTypeEnum.ASSET), "assetid",
                AttributeTypeEnum.ASSET, aid);
        map.put("assetid", asset);
        return map;
    }

    protected Map<String, AttributeData> groupMap(long id, boolean isRequired,
                                                boolean isMultiple) {

        AssetId aid = new AssetIdImpl(c, id);

        Map<String, AttributeData> map = new HashMap<String, AttributeData>();

        map.put("required", attrData("required", isRequired));
        map.put("multiple", attrData("multiple", isMultiple));

        map.put("assetid", attrData("assetid", AttributeTypeEnum.ASSET, aid));

        return map;
    }
}
