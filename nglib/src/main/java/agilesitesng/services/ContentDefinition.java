package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.AssetId;
import com.fatwire.assetapi.data.AttributeData;
import com.fatwire.assetapi.data.AttributeDataImpl;
import com.fatwire.assetapi.data.MutableAssetData;
import com.fatwire.assetapi.def.AttributeTypeEnum;
import com.openmarket.xcelerate.asset.AssetIdImpl;
import com.openmarket.xcelerate.asset.AttributeDefImpl;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class ContentDefinition extends ParentDefinition {

    String parentType;
    public ContentDefinition(ICS ics) {
        super(ics);
        this.parentType = ics.GetVar("parentType");
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

        //TODO manage parents
/*

        i = 0;
        for (Long id : parentIds) {
            boolean mul = isMultipleParents.get(i);
            boolean req = isRequiredParents.get(i);
            Map<?, ?> map = groupMap(id.longValue(), mul, req);
            ad.getAttributeData("Groups").addData(map);
            i++;
        }
*/

    }

}
