package agilesites.api;

import java.util.Date;
import java.util.Map;

/**
 * Created by msciab on 11/08/15.
 */
public class AgileAsset implements Asset {
    @Override
    public String getSite() {
        return null;
    }

    @Override
    public Id getId() {
        return null;
    }

    @Override
    public String getC() {
        return null;
    }

    @Override
    public Long getCid() {
        return null;
    }

    @Override
    public String getTemplate() {
        return null;
    }

    @Override
    public Iterable<Integer> getAssocRange(String assoc) {
        return null;
    }

    @Override
    public Long getAssocId(String assoc) {
        return null;
    }

    @Override
    public Long getAssocId(String assoc, int pos) {
        return null;
    }

    @Override
    public String getAssocType(String assoc) {
        return null;
    }

    @Override
    public String getAssocType(String assoc, int pos) {
        return null;
    }

    @Override
    public String getSubtype() {
        return null;
    }

    @Override
    public String getName() {
        return null;
    }

    @Override
    public String getDescription() {
        return null;
    }

    @Override
    public String getFilename() {
        return null;
    }

    @Override
    public String getPath() {
        return null;
    }

    @Override
    public Date getStartDate() {
        return null;
    }

    @Override
    public Date getEndDate() {
        return null;
    }

    @Override
    public int getSize(String attribute) {
        return 0;
    }

    @Override
    public Long getCid(String attribute) {
        return null;
    }

    @Override
    public String getFieldString(String name) {
        return null;
    }

    @Override
    public Date getFieldDate(String name) {
        return null;
    }

    @Override
    public int getFieldInt(String name) {
        return 0;
    }

    @Override
    public long getFieldLong(String name) {
        return 0;
    }

    @Override
    public Asset getAsset(String attribute, String type, AssetDeps logdep) {
        return null;
    }

    @Override
    public Asset getAsset(String attribute, String type) {
        return null;
    }

    @Override
    public Asset getAsset(String attribute, String type, int i) {
        return null;
    }

    @Override
    public Asset getAsset(String attribute, int i, String type, AssetDeps logdep) {
        return null;
    }

    @Override
    public String getBlobUrl(String attribute, Arg... args) {
        return null;
    }

    @Override
    public String getBlobUrl(String attribute, String mimeType, Arg... args) {
        return null;
    }

    @Override
    public String getBlobUrl(String attribute, int pos, String mimeType, Arg... args) {
        return null;
    }

    @Override
    public Long getCid(String attribute, int n) {
        return null;
    }

    @Override
    public String getString(String attribute) {
        return null;
    }

    @Override
    public String getString(String attribute, int n) {
        return null;
    }

    @Override
    public Integer getInt(String attribute) {
        return null;
    }

    @Override
    public Integer getInt(String attribute, int n) {
        return null;
    }

    @Override
    public Long getLong(String attribute) {
        return null;
    }

    @Override
    public Long getLong(String attribute, int n) {
        return null;
    }

    @Override
    public Double getDouble(String attribute) {
        return null;
    }

    @Override
    public Double getDouble(String attribute, int n) {
        return null;
    }

    @Override
    public Date getDate(String attribute) {
        return null;
    }

    @Override
    public Date getDate(String attribute, int n) {
        return null;
    }

    @Override
    public Iterable<Integer> getRange(String attribute) {
        return null;
    }

    @Override
    public String getUrl(Arg... args) {
        return null;
    }

    @Override
    public boolean exists(String attribute) {
        return false;
    }

    @Override
    public boolean exists(String attribute, int n) {
        return false;
    }

    @Override
    public String editString(String attribute) {
        return null;
    }

    @Override
    public String editString(String attribute, int n) {
        return null;
    }

    @Override
    public String editString(String attribute, int n, String params, Arg... args) {
        return null;
    }

    @Override
    public String editText(String attribute, int n, String params) {
        return null;
    }

    @Override
    public String editString(String attribute, String params, Arg... args) {
        return null;
    }

    @Override
    public String editText(String attribute, String params) {
        return null;
    }

    @Override
    public String call(String name, Arg... args) {
        return null;
    }

    @Override
    public String slotList(String field, String type, String template, Arg... args) throws IllegalArgumentException {
        return null;
    }

    @Override
    public String slotList(String field, int maxRows, String type, String template, Arg... args) throws IllegalArgumentException {
        return null;
    }

    @Override
    public String slotEmpty(String attribute, String type, String template, String emptyText) throws IllegalArgumentException {
        return null;
    }

    @Override
    public String slot(String attribute, int i, String type, String template, String emptyText, Arg... args) throws IllegalArgumentException {
        return null;
    }

    @Override
    public String slot(String attribute, String type, String template, String emptyText, Arg... args) throws IllegalArgumentException {
        return null;
    }

    public Map map() {
        return null;
    }

    @Override
    public String dump() {
        return null;
    }

    @Override
    public String dump(String attribute) {
        return null;
    }
}
