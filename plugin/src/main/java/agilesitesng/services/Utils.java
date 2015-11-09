package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.Api;
import agilesites.api.AssetTag;
import agilesites.api.PublicationTag;
import com.fatwire.assetapi.data.AssetData;
import com.fatwire.assetapi.data.AttributeDataImpl;
import com.fatwire.assetapi.data.BlobObject;
import com.fatwire.assetapi.data.BlobObjectImpl;
import com.fatwire.assetapi.def.AttributeTypeEnum;
import com.openmarket.xcelerate.asset.AttributeDefImpl;

import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by msciab on 23/08/15.
 */
public class Utils {

    /**
     * Decode a value=site:id@site into c/cid/site
     * Return true if either c/cid/site are provided or value is in the expected format.
     * Otherwise set the error in the error variable
     */
    public static boolean decodeAssetId(ICS ics) {

        if (ics.GetVar("c") != null && ics.GetVar("cid") != null && ics.GetVar("site") != null)
            return true;

        String value = ics.GetVar("value");
        if (value == null) {
            ics.SetVar("error", "no value provided");
            return false;
        }

        int posColon = value.indexOf(":");
        int posAt = value.indexOf("@");

        if (posColon == -1 || posAt == -1) {
            ics.SetVar("error", "the id is not in type:id@site format");
            return false;
        }

        String c = value.substring(0, posColon);
        String cid = value.substring(posColon + 1, posAt);
        String site = value.substring(posAt + 1);
        if (c.trim().length() == 0) {
            ics.SetVar("error", "empty type");
            return false;

        }

        boolean isNumeric = true;
        try {
            Long.parseLong(cid);
        } catch (Exception ex) {
            ics.SetVar("error", "cid not in numeric format");
            isNumeric = false;
        }

        if (!isNumeric) {
            // set cid loading the asset by name
            String asset = Api.tmp();
            System.out.println("c=" + c + " site=" + site);
            AssetTag.load().name(asset).type(c).site(site).field("name").value(cid).run(ics);
            if (ics.GetObj(asset) == null) {
                ics.SetVar("error", "cannot find the asset named " + cid);
                return false;
            }
            AssetTag.get().name(asset).field("id").output("cid").run(ics);
        } else {
            ics.SetVar("cid", cid);
        }

        if (site.trim().length() == 0) {
            ics.SetVar("error", "empty site");
            return false;
        }

        ics.SetVar("c", c);
        ics.SetVar("site", site);
        return true;
    }

    /**
     * Return the site id - load the site by the site
     *
     * @param ics
     * @return
     */
    public static String siteid(ICS ics, String sitename) {
        String site = Api.tmp();
        PublicationTag.load().name(site).field("NAME").value(sitename).run(ics);
        if (ics.GetObj(site) == null)
            return "-1";
        return PublicationTag.get().name(site).field("id").eval(ics, "OUTPUT");
    }


    /**
     * Dump variables
     *
     * @param ics
     * @return
     */
    public static String dumpVars(ICS ics) {
        Enumeration e = ics.GetVars();
        StringBuilder sb = new StringBuilder();
        String op = null;
        while (e.hasMoreElements()) {
            String v = e.nextElement().toString();
            if (v.equals("op"))
                op = ics.GetVar(v);
            else
                sb.append(v).append("=").append(ics.GetVar(v)).append("\n");
        }
        return "==== " + op + " ====\n" + sb.toString();
    }

    /**
     * dump variables starting with a prefix
     */
    public static String dumpVarsByPrefix(ICS ics, String prefix) {
        Enumeration e = ics.GetVars();
        StringBuilder sb = new StringBuilder();
        while (e.hasMoreElements()) {
            String v = e.nextElement().toString();
            if (v.startsWith(prefix))
                sb.append(v).append("=").append(ics.GetVar(v)).append("\n");
        }
        return "==== prefix: " + prefix + " ====\n" + sb.toString();
    }

    /**
     * Create a list from multiple arguments
     *
     * @param objs
     * @return
     */
    public static List<Object> list(Object... objs) {
        List result = new ArrayList();
        for (Object obj : objs)
            result.add(obj);
        // System.out.println(result);
        return result;
    }

    /**
     * Create a list from multiple arguments
     *
     * @param objs
     * @return
     */
    public static List<String> listString(String... objs) {
        List<String> result = new ArrayList<String>();
        for (String obj : objs)
            result.add(obj);
        // System.out.println(result);
        return result;
    }

    /**
     * Create a list from multiple arguments
     *
     * @param objs
     * @return
     */
    public static List<AssetData> listData(AssetData... objs) {
        List<AssetData> result = new ArrayList<AssetData>();
        for (AssetData obj : objs)
            result.add(obj);
        // System.out.println(result);
        return result;
    }

    /**
     * from an array to a list
     *
     * @param array
     * @return
     */
    public static List<Object> array2list(Object[] array) {
        List<Object> ls = new ArrayList<Object>();
        for (Object s : array)
            ls.add(s);
        return ls;
    }

    /**
     * from an array to a list
     *
     * @param array
     * @return
     */
    public static List<String> array2listString(String[] array) {
        List<String> ls = new ArrayList<String>();
        for (String s : array)
            ls.add(s);
        return ls;
    }

    public static String dumpAssetData(AssetData data) {
        String s = new com.thoughtworks.xstream.XStream().toXML(data);
        try {
            FileWriter fw = new FileWriter("/tmp/out.xml", true);
            fw.write(s);
            fw.close();
        } catch (Exception ex) {
        }

        return s;
    }

    private static AttributeDefImpl defn(String name, AttributeTypeEnum type) {
        return new AttributeDefImpl(name, type);
    }

    /**
     * String attribute
     */
    public static AttributeDataImpl attrString(String name, String value) {
        AttributeTypeEnum type = AttributeTypeEnum.STRING;
        return new AttributeDataImpl(defn(name, type), name, type, value);
    }

    /**
     * Blob Attribute
     *
     * @param name
     * @param value
     * @return
     */
    public static AttributeDataImpl attrBlob(String name, BlobObject value) {
        AttributeTypeEnum type = AttributeTypeEnum.URL;
        return new AttributeDataImpl(defn(name, type), name, type, value);
    }

    /**
     * Structure default arguments
     *
     * @param name
     * @param value
     * @return
     */
    public static AttributeDataImpl attrStructKV(String name, String value) {
        HashMap map = new HashMap<String, Object>();
        map.put("name", attrString("name", name));
        map.put("value", attrString("value", value));
        return attrStruct("Structure defaultarguments", map);
    }

    /**
     * Struct (map) attribute
     *
     * @param name
     * @param value
     * @return
     */
    public static AttributeDataImpl attrStruct(String name, Map<String, Object> value) {
        AttributeTypeEnum type = AttributeTypeEnum.STRUCT;
        return new AttributeDataImpl(defn(name, type), name, type, value);
    }

    /**
     * @return Array (list) attribute
     */
    public static AttributeDataImpl attrArray(String name, Object... value) {
        AttributeTypeEnum type = AttributeTypeEnum.ARRAY;
        return new AttributeDataImpl(defn(name, type), name, type,
                (Object) array2list(value));

    }

    /**
     * @return Blob Attribute
     */
    public static AttributeDataImpl attrBlob(String name,
                                             String folder,
                                             String filename,
                                             String value) {
        AttributeTypeEnum type = AttributeTypeEnum.URL;
        return new AttributeDataImpl(defn(name, type), name, type,
                new BlobObjectImpl(folder + "/" + filename, folder,
                        value.getBytes()));

    }

    /**
     * @return a parsed long or  zero
     */
    public static long parseLongOrZero(String l) {
        if (l == null)
            return 0;
        try {
            return Long.parseLong(l);
        } catch (Exception ex) {
            return 0;
        }
    }


    /**
     * @return Not null or the default value
     */
    public static String nnOr(String s, String dflt) {
        if (s != null && !s.trim().equals(""))
            return s;
        return dflt;
    }

    /**
     * Check if the parameter is a substring in values
     * Throw exception otherwise
     */
    public static String oneOf(String s, String values) throws Exception {
        if (s == null || values == null)
            throw new Exception("bad parameters");
        if (values.indexOf(s) != -1)
            return s;
        throw new Exception("not one of " + values);
    }


    public static boolean bool(String s) {
        if (s == null || s.trim().equals("0") || s.trim().toLowerCase().startsWith("f"))
            return false;
        return true;
    }

    public static String[] arrayString(String... t) {
        return t;
    }

    public static String[] splitOnPipe(String s) {
        if (s == null)
            return new String[0];
        StringTokenizer st = new StringTokenizer(s, "|");
        String[] res;
        int n = st.countTokens();
        if (n == 0) {
            res = arrayString(s);
        } else {
            res = new String[n];
            for (int i = 0; i < n; i++)
                res[i] = st.nextToken();
        }
        return res;
    }

    private static SimpleDateFormat fmt = new SimpleDateFormat(
            "yyyy-MM-dd HH:mm:ss");

    /**
     * Convert as a date, null if error
     */
    public static java.util.Date toDate(String s) {
        if (s != null) {
            try {
                return fmt.parse(s);
            } catch (Exception e) {
            }
        }
        return null;
    }
}
