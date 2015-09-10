package agilesites.api;

import static agilesites.api.Api.*;

import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;


/**
 * Model class to pass data around (mostly to the picker)
 *
 * @author msciab
 */
public class Model implements Content {

    private Map<String, List<String>> map;

    // initialize the map from the arguments
    private void init(Arg... args) {
        for (agilesites.api.Arg arg : args) {
            if (arg.value == null)
                continue;
            List<String> list = map.get(arg.name);
            if (list == null)
                map.put(arg.name, list = new LinkedList<String>());
            if (arg instanceof agilesites.api.Args) {
                agilesites.api.Args arglist = (agilesites.api.Args) arg;
                for (String value : arglist.values)
                    if (value != null)
                        list.add(value);
            } else {
                list.add(arg.value);
            }
        }
    }

    /**
     * @return a from  a sequence of args - if you need the same arg more than once, pass the same argument multiple times
     */
    public Model(Arg... args) {
        map = new HashMap<String, List<String>>();
        init(args);
    }

    /**
     * @return a model with a sequence of args, building it on top of an existing  - if you need the same arg more than once, pass the same argument multiple times
     */
    public Model(Model m, agilesites.api.Arg... args) {
        if (m == null)
            map = new HashMap<String, List<String>>();
        else
            map = new HashMap<String, List<String>>(m.map);
        init(args);
    }

    /**
     * @return if a value exists in the model
     */
    @Override
    public boolean exists(String name) {
        // System.out.println(map);
        return map.get(name) != null;
    }

    /**
     * @return if the nth value (1-based) exists in the model
     */
    @Override
    public boolean exists(String name, int pos) {
        return pos > 0 && map.get(name) != null && map.get(name).size() >= pos;
    }

    /**
     * @return the value as a string
     */
    @Override
    public String getString(String name) {
        return exists(name) ? map.get(name).get(0) : null;
    }

    /**
     * @return the nth value as a string
     */
    @Override
    public String getString(String name, int n) {
        return exists(name, n) ? map.get(name).get(n - 1) : null;
    }

    /**
     * @return the value as a int
     */
    @Override
    public Integer getInt(String name) {
        return toInt(getString(name));
    }

    /**
     * @return the nth value as a int
     */
    @Override
    public Integer getInt(String name, int n) {
        return toInt(getString(name, n));
    }

    /**
     * @return the value as a long
     */
    @Override
    public Long getLong(String name) {
        return toLong(getString(name));
    }

    /**
     * @return the nth value as a long
     */
    @Override
    public Long getLong(String name, int n) {
        return toLong(getString(name, n));
    }

    /**
     * @return the value as a date
     */
    @Override
    public Date getDate(String name) {
        return toDate(getString(name));
    }

    /**
     * @return the nth value as a date
     */
    @Override
    public Date getDate(String name, int n) {
        return toDate(getString(name, n));
    }

    /**
     * @return the size of the attribute
     */
    @Override
    public int getSize(String attribute) {
        if (exists(attribute))
            return map.get(attribute).size();
        else
            return 0;
    }

    /**
     * @return the range of the attribute: an iterator returning the valid values
     * for example:
     * <pre>for(int i: m.getRange("attr")) { doSometing(m.getString("attr", i)); }</pre>
     */
    @Override
    public Iterable<Integer> getRange(String attribute) {
        return new Range(getSize(attribute));
    }

    /**
     * @return a string dump of the model
     */
    @Override
    public String dump() {
        StringBuilder sb = new StringBuilder();
        for (String k : map.keySet()) {
            sb.append(dump(k));
        }
        return sb.toString();
    }

    /**
     * @return a string dump of an attribute
     */
    @Override
    public String dump(String attribute) {
        List<String> list = map.get(attribute);
        if (list == null)
            return "";
        StringBuilder sb = new StringBuilder();
        sb.append(attribute).append("=");
        for (String s : list) {
            sb.append(s).append(",");
        }
        sb.setCharAt(sb.length() - 1, '\n');
        return sb.toString();
    }

}
