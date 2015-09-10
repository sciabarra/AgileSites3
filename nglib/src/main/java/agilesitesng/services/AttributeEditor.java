package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.*;

// the attribute editor
public class AttributeEditor extends Asset {

    private String xml;

    public AttributeEditor(ICS ics) {
        super("AttrTypes", ics);
        this.xml = xml;
    }

    private void initXml(String name, String xml) {

        this.xml = xml;
    }

    @Override
    public void setData(MutableAssetData ad) {
        BlobObject blob = new BlobObjectImpl(name.toLowerCase()
                + ".xml", "AttrTypes",
                xml.getBytes());
        ad.getAttributeData("urlxml").setData(blob);
        //System.out.println(blob);
    }
}
