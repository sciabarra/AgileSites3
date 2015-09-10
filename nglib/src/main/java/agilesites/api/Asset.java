package agilesites.api;

import java.util.Date;


public interface Asset extends Content {

    /**
     * @return the current site name
     */
    public abstract String getSite();

    /**
     * @return the current asset id
     */
    public abstract Id getId();

    /**
     * @return the current asset type
     */
    public abstract String getC();

    /**
     * @return the current asset id, or null if undefined
     */
    public abstract Long getCid();

    /**
     * @return the current template or null if undefined
     */
    public abstract String getTemplate();

    /**
     * @param assoc   association name
     * @return the range of an asset association
     */
    public abstract Iterable<Integer> getAssocRange(String assoc);

    /**
     * @param assoc    association name
     * @return the id of the first associated asset
     */
    public abstract Long getAssocId(String assoc);

    /**
     * @param assoc    association name
     * @param pos index
     * @return the id of the nth associated asset
     */
    public abstract Long getAssocId(String assoc, int pos);

    /**
     * @param assoc    association name
     * @return the type of the first associated asset
     */
    public abstract String getAssocType(String assoc);

    /**
     * @param assoc    association name
     * @param pos index
     * @return the type of the nth associated asset
     */
    public abstract String getAssocType(String assoc, int pos);

    /**
     * @return the current asset subtype, or the void string if no subtype
     */
    public abstract String getSubtype();

    /**
     * @return the current asset name
     */
    public abstract String getName();

    /**
     * @return the current asset description, or the name if the description is
     * undefined
     */
    public abstract String getDescription();

    /**
     * @return the current asset file
     */
    public abstract String getFilename();

    /**
     * @return the Current asset path
     */
    public abstract String getPath();

    /**
     * @return the current asset start date or null if undefined
     */
    public abstract Date getStartDate();

    /**
     * @return the current asset end date or null if undefined
     */
    public abstract Date getEndDate();

    /**
     * @param attribute name
     * @return the number of elements in the attribute
     */
    public abstract int getSize(String attribute);

    /**
     * @param attribute name
     * @return he first attribute of the attribute list as an id (long), or null
     * if not found
     */
    public abstract Long getCid(String attribute);

    /**
     * @param name of the field
     * @return a named field from the asset as a string
     */
    public String getFieldString(String name);

    /**
     * @param name of the field
     * @return a named field from the asset as a date
     */
    public Date getFieldDate(String name);

    /**
     * @param name of the field
     * @return a named field from the asset as an int
     */
    public int getFieldInt(String name);

    /**
     * @param name of the field
     * @return a named field from the asset as a long
     */
    public long getFieldLong(String name);

    /**
     * Specify the dependency type you are going to use when accessing this
     * asset.
     *
     * @param attribute name
     * @param type      of the attribute
     * @param logdep dependency type
     * @return the related asset pointed by the attribute of the given type
     */
    public abstract Asset getAsset(String attribute, String type,
                                   AssetDeps logdep);

    /**
     * @param attribute    name
     * @param type of the attribute
     * @return the related asset pointed by the attribute of the given type.
     */
    public abstract Asset getAsset(String attribute, String type);

    /**
     * @param attribute    name
     * @param type of the attribute
     * @param i index
     * @return the related asset pointed by the nth attribute of the given type.
     */
    public abstract Asset getAsset(String attribute, String type, int i);

    /**
     * @param attribute    name
     * @param i index
     * @param type of the attribute
     * @param logdep dependency type
     * @return the related asset pointed by the nth attribute of the given type.
     * specifing the dependency type you are going to use.
     */
    public abstract Asset getAsset(String attribute, int i, String type,
                                   AssetDeps logdep);

    /**
     * @param attribute    name
     * @param args additional arguments of the blob
     * @return the url of the first attribute, with optional args
     */
    public abstract String getBlobUrl(String attribute, Arg... args);

    /**
     * @param attribute    name
     * @param mimeType of the blob
     * @param args additional arguments
     * @return the blob url of the first attribute, with optional args
     */
    public abstract String getBlobUrl(String attribute, String mimeType,
                                      Arg... args);

    /**
     * @param attribute    name
     * @param pos index
     * @param mimeType of the blob
     * @param args additional
     * @return the blob url of the nth attribute, with optional args
     */
    public abstract String getBlobUrl(String attribute, int pos,
                                      String mimeType, Arg... args);

    /**
     * @param attribute    name
     * @param n index
     * @return the nth attribute of the named attribute as an id (long), or null
     * if not found
     */
    public abstract Long getCid(String attribute, int n);

    /**
     * @return the first attribute of the the named attribute as a string, or
     * null if not found
     */
    public abstract String getString(String attribute);

    /**
     * @return the nth named attribute as a string, or null if not found
     */
    public abstract String getString(String attribute, int n);

    /**
     * @return the first attribute of the the attribute list as an int, or null
     * if not found
     */
    public abstract Integer getInt(String attribute);

    /**
     * @return the nth attribute of the the attribute list as an int, or null if
     * not found
     */
    public abstract Integer getInt(String attribute, int n);

    /**
     * @return the first attribute of the the attribute list as a long, or null
     * if not found
     */
    public abstract Long getLong(String attribute);

    /**
     * @return the nth attribute of the the attribute list as an int, or null if
     * not found
     */
    public abstract Long getLong(String attribute, int n);


    /**
     * @return the first attribute of the the attribute list as a double, or null
     * if not found
     */
    public abstract Double getDouble(String attribute);

    /**
     * @return the nth attribute of the the attribute list as a double, or null if
     * not found
     */
    public abstract Double getDouble(String attribute, int n);

    /**
     * @return the first attribute of the the attribute list as an int, or null
     * if not found
     */
    public abstract Date getDate(String attribute);

    /**
     * @return the nth attribute of the the attribute list as an int, or null if
     * not found
     */
    public abstract Date getDate(String attribute, int n);

    /**
     * @return an iterable of the attribute list
     */
    public abstract Iterable<Integer> getRange(String attribute);

    /**
     * @return the URL to render this asset
     */
    public abstract String getUrl(Arg... args);

    /**
     * @return if the attribute exist
     */
    public abstract boolean exists(String attribute);

    /**
     * @return if the nth attribute exist
     */
    public abstract boolean exists(String attribute, int n);

    /**
     * @return rendering the attribute as an editable string in insite mode
     */
    public abstract String editString(String attribute);

    /**
     * @return rendering the nth attribute as an editable string in insite mode
     */
    public abstract String editString(String attribute, int n);

    /**
     * @return rendering  of the n-th element of the given attribute, using the given parameters (as editable)
     */
    public abstract String editString(String attribute, int n, String params,
                                      Arg... args);

    /**
     * @return rendering as editable (or just the text  if not insite) the nth named attribute as a string, or
     * null if not found and pass additional parameters using the CK editor
     */
    public abstract String editText(String attribute, int n, String params);

    /**
     * @return rendering as editable (or just the text  if not insite) the first named attribute as a string, or
     * null if not found and pass additional parameters
     */
    public abstract String editString(String attribute, String params,
                                      Arg... args);

    /**
     * @return rendering as editable  (or return if not insite) the first named attribute as a string, or
     * null if not found using the CK editor
     */
    public abstract String editText(String attribute, String params);

    /**
     * @return invocation the template using the current asset as current asset, optionally
     * passing a set of parameters
     */
    public abstract String call(String name, Arg... args);

    /**
     * @return rendering of a list of slots pointed by the asset field using the the specified
     * template
     */
    public abstract String slotList(String field, String type, String template,
                                    Arg... args) throws IllegalArgumentException;


    /**
     * @return rendering of a list of slots pointed by the asset field using the the specified
     * template
     */
    public abstract String slotList(String field, int maxRows, String type, String template,
                                    Arg... args) throws IllegalArgumentException;

    /**
     * @return rendering of an empty slot, useful as placeholder to add content
     */
    public abstract String slotEmpty(String attribute, String type,
                                     String template, String emptyText) throws IllegalArgumentException;

    /**
     * @return rendering of a single slot pointed by the i-th asset field using the the
     * specified template.
     */
    public abstract String slot(String attribute, int i, String type,
                                String template, String emptyText, Arg... args)
            throws IllegalArgumentException;

    /**
     * @return rendering of a single slot pointed by the first asset field using the the
     * specified template.
     */
    public abstract String slot(String attribute, String type, String template,
                                String emptyText, Arg... args) throws IllegalArgumentException;

}