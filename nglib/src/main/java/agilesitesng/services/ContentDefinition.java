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
}
