package agilesites.api;

/**
 * Base class for implementing an "agile" site with WebCenter Sites
 */
public class AgileSite {

    private String sitePrefix = getClass().getName()+"_";

    public String getAttributeType(String type) {
        if(type.equals("Page"))
            return "PageAttribute";
        if(type.startsWith(sitePrefix))
            return sitePrefix+"A";
        return null;
    }
}
