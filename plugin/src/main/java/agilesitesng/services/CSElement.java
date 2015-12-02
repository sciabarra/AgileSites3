package agilesitesng.services;

import java.util.List;
import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.BlobObject;
import com.fatwire.assetapi.data.BlobObjectImpl;
import com.fatwire.assetapi.data.MutableAssetData;

/**
 * CSElement definition class
 */
public class CSElement extends Asset {

    private String elementName;
    private String elementCode;

    /**
     * Create a CSElement invoking the given elementClass
     */
    public CSElement(ICS ics) {
        super("CSElement", ics);
        this.elementName = ics.GetVar("element");
        this.elementCode = ics.GetVar("body");
        this.elementName = ics.GetVar("ext");
    }

    public List<String> getAttributes() {
        return Utils.listString("name", "description", "elementname",
                "rootelement", "url", "resdetails1", "resdetails2");
    }

    public void setData(MutableAssetData data) {

        // root element
        data.getAttributeData("rootelement").setData(elementName);
        // addAttribute(data, "rootelement", element);

        // element name
        data.getAttributeData("elementname").setData(elementName);
        // addAttribute(data, "elementname", element);

        data.getAttributeData("resdetails1").setData(
                "eid=" + data.getAssetId().getId());

        data.getAttributeData("resdetails2").setData(
                "timestamp=" + System.currentTimeMillis());

        // blob
        byte[] bytes = elementCode.getBytes();
        BlobObject blob = new BlobObjectImpl(elementCode, "AgileSites", bytes);
        data.getAttributeData("url").setData(blob);

        // data.getAttributeData("createdby").setData("agilesites");
        // data.getAttributeData("createddate").setData(new Date());
        // data.getAttributeData("Mapping").setData(new ArrayList());
        // data.getAttributeData("Mapping").setData(new AttributeMan HashMap());
    }

}
