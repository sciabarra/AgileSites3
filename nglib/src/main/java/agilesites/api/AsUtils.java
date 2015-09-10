package agilesites.api;

import com.fatwire.assetapi.data.AssetData;
import com.fatwire.assetapi.data.AttributeDataImpl;
import com.fatwire.assetapi.data.BlobObject;
import com.fatwire.assetapi.data.BlobObjectImpl;
import com.fatwire.assetapi.def.AttributeTypeEnum;
import com.openmarket.xcelerate.asset.AttributeDefImpl;

import java.io.*;
import java.lang.reflect.Field;
import java.util.*;

/**
 * AgileSites and Sites specific utils and support functions
 *
 * @author msciab
 */
public class AsUtils {


    /**
     * Create a list from multiple arguments
     */
    //@SuppressWarnings({"rawtypes", "unchecked"})
    public static List list(Object... objs) {
        List result = new ArrayList();
        for (Object obj : objs)
            result.add(obj);
        // System.out.println(result);
        return result;
    }

    /**
     * Create a list from multiple arguments
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
     */
    public static List<Object> array2list(Object[] array) {
        List<Object> ls = new ArrayList<Object>();
        for (Object s : array)
            ls.add(s);
        return ls;
    }

    /**
     * from an array to a list of Strings
     */
    public static List<String> array2listString(String[] array) {
        List<String> ls = new ArrayList<String>();
        for (String s : array)
            ls.add(s);
        return ls;
    }

    /**
     * Dump AssetAPI asset data in an xml format
     */
    public static String dumpAssetData(AssetData data, File file) {
        String s = new com.thoughtworks.xstream.XStream().toXML(data);
        if (file != null)
            try {
                FileWriter fw = new FileWriter(file, true);
                fw.write(s);
                fw.close();
            } catch (Exception ex) {
            }
        return s;
    }

    private static AttributeDefImpl adef(String name, AttributeTypeEnum type) {
        return new AttributeDefImpl(name, type);
    }

    /**
     * String attribute
     */
    public static AttributeDataImpl attrString(String name, String value) {
        AttributeTypeEnum type = AttributeTypeEnum.STRING;
        return new AttributeDataImpl(adef(name, type), name, type, value);
    }

    /**
     * Blob Attribute
     */
    public static AttributeDataImpl attrBlob(String name, BlobObject value) {
        AttributeTypeEnum type = AttributeTypeEnum.URL;
        return new AttributeDataImpl(adef(name, type), name, type, value);
    }

    /**
     * Structure default arguments
     */
    //@SuppressWarnings({"unchecked", "rawtypes"})
    public static AttributeDataImpl attrStructKV(String name, String value) {
        HashMap map = new HashMap<String, Object>();
        map.put("name", attrString("name", name));
        map.put("value", attrString("value", value));
        return attrStruct("Structure defaultarguments", map);
    }

    /**
     * Struct (map) attribute
     */
    public static AttributeDataImpl attrStruct(String name,
                                               Map<String, Object> value) {
        AttributeTypeEnum type = AttributeTypeEnum.STRUCT;
        return new AttributeDataImpl(adef(name, type), name, type, value);
    }

    /**
     * Array (list) attribute
     */
    public static AttributeDataImpl attrArray(String name, Object... value) {
        AttributeTypeEnum type = AttributeTypeEnum.ARRAY;
        return new AttributeDataImpl(adef(name, type), name, type,
                (Object) array2list(value));

    }

    /**
     * Blob Attribute
     */
    public static AttributeDataImpl attrBlob(String name, String folder,
                                             String filename, String value) {
        AttributeTypeEnum type = AttributeTypeEnum.URL;
        return new AttributeDataImpl(adef(name, type), name, type,
                new BlobObjectImpl(folder + "/" + filename, folder,
                        value.getBytes()));

    }

    /**
     * Get a resource from the classpath
     */
    public static String getResource(String res) {
        InputStream is = null;
        try {
            return new java.util.Scanner(
                    is = AsUtils.class.getResourceAsStream(res)).useDelimiter(
                    "\\A").next();
        } finally {
            try {
                is.close();
            } catch (Exception e) {
            }
        }
    }

    /**
     * Get a resource property file from the classpath
     */
    public static Properties getResourceProperties(String res) {
        InputStream is = null;
        Properties prp = new Properties();
        try {
            is = AsUtils.class.getResourceAsStream(res);
            prp.load(is);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (Exception e) {
            }
        }
        return prp;
    }

    /**
     * Hexadecimal dump of a string
     */
    public static String hexDump(String s) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            sb.append(String.format("%c=%2s ", c, Integer.toHexString(c)));
            if (i % 8 == 7)
                sb.append("\n");
        }
        sb.append("\n");
        return sb.toString();
    }

    /**
     * Return a blob filename as requested from AssetApi BlobObject
     */
    public static String normalizeBlobFilename(String filepath) {
        filepath = filepath.replace("\\", "/");
        String filename = filepath;
        if (filepath.lastIndexOf("/") > 0) {
            filename = filepath.substring(filepath.lastIndexOf("/") + 1,
                    filepath.length());
        }
        int version = filename.lastIndexOf(",");
        int extensionPos = filename.lastIndexOf(".", filename.length());
        if (version > 0) {
            String extension = "";
            if (extensionPos > 0)
                extension = filename.substring(extensionPos, filename.length());
            return filename.substring(0, version) + extension;
        }
        return filename;
    }

    /**
     * Convenience method to dump the stream resulting from the Picker
     */
    public static String dumpStream(String html) {
        Sequencer seq = new Sequencer(html);
        StringBuilder sb = new StringBuilder(seq.header());
        while (seq.hasNext()) {
            Call call = seq.next();
            sb.append(call.toString());
            sb.append(seq.header());
        }
        return sb.toString();
    }

    /**
     * Print on standard output some contents
     */
    public static void out(String message, Content... contents) {
        System.out.println(message);
        for (Content c : contents) {
            System.out.println(c.dump());
        }
    }

    /**
     * Print on standard output some contents
     */
    public static void out(Content... contents) {
        for (Content c : contents) {
            System.out.println(c.dump());
        }
    }

    /**
     * Print on standard output a content attributes
     */
    public static void out(String message, Content content, String name) {
        System.out.println(message + ": " + content.dump(name));
    }

    /**
     * Print on standard output a content attributes
     */
    public static void out(Content content, String name) {
        System.out.println(content.dump(name));
    }
}
