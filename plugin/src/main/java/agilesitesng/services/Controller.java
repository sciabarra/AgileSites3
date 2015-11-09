package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.BlobObject;
import com.fatwire.assetapi.data.BlobObjectImpl;
import com.fatwire.assetapi.data.MutableAssetData;

import java.util.List;

/**
 * CSElement definition class
 */
public class Controller extends Asset {

    private String body;
    private String elementName;
    private String file;
    private String folder;

    /**
     * Create a CSElement invoking the given elementClass
     */
    public Controller(ICS ics) {
        super("WCS_Controller", ics);
        body = ics.GetVar("filebody");
        file = ics.GetVar("filename")+"."+ics.GetVar("fileext");
        folder = ics.GetVar("filefolder");
        elementName = "WCS_Controller/"+name.replace('.', '/');
     }

    public void setData(MutableAssetData data) {
        data.getAttributeData("rootelement").setData(elementName);
        data.getAttributeData("elementname").setData(elementName);
        data.getAttributeData("resdetails1").setData(
                "eid=" + data.getAssetId().getId());
        data.getAttributeData("resdetails2").setData(
                "timestamp=" + System.currentTimeMillis());

        // blob
        byte[] bytes = body.getBytes();
        BlobObject blob = new BlobObjectImpl(file, folder, bytes);
        data.getAttributeData("url").setData(blob);

        // blob
        //byte[] bytes = elementCode.getBytes();
        //BlobObject blob = new BlobObjectImpl(elementCode, "AgileSites", bytes);
        //data.getAttributeData("url").setData(blob);

        // data.getAttributeData("createdby").setData("agilesites");
        // data.getAttributeData("createddate").setData(new Date());
        // data.getAttributeData("Mapping").setData(new ArrayList());
        // data.getAttributeData("Mapping").setData(new AttributeMan HashMap());
    }

}
