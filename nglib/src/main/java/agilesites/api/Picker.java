package agilesites.api;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.Iterator;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.InputStream;

import static agilesites.api.Api.*;

/**
 * Picker is a template engine building html pages or snippets using
 * replacements and modifications in the html with jQuery-style selectors.
 *
 * @author msciab
 */
public class Picker {

    private static Log log = Log.getLog(Picker.class);
    private StringBuffer warnings = new StringBuffer();

    // we need a a better default
    private static final String baseUrl = "http://localhost:8080/";
    private Stack<Element> stack = new Stack<Element>();

    private Element top;
    private Element bottom;
    // last select operation was ok?
    private boolean selectOk;

    private void warn(Exception ex, String warning) {
        warnings.append("<li>").append(warning); //
        if (ex != null)
            warnings.append("<blockquote><pre>").append(ex2str(ex))//
                    .append("</pre></blockquote>");
        warnings.append("</li>");
        log.warn(warning);
    }

    private String warnings() {
        if (warnings.length() > 0) {
            return "<ol style='font-color: red'>" + warnings.toString()
                    + "</ol>";
        } else {
            return "";
        }
    }

    private void push(Element elem) {
        stack.push(elem);
        top = elem;
    }

    private void pop() {
        stack.pop();
        top = stack.lastElement();
    }

    /**
     * @return a new picker from a given resource in the classpath selected with a css query
     */
    public static Picker load(String resource, String cssq) {
        return new Picker(Picker.class.getResourceAsStream(resource), null,
                cssq);
    }

    /**
     * @return a picker from a given resource in the classpath selected with a
     * css query
     */
    public static Picker load(String resource) {
        return new Picker(Picker.class.getResourceAsStream(resource), null,
                null);
    }

    /**
     * @return a new picker from a string
     */
    public static Picker create(String html) {
        return new Picker(null, html, null);
    }

    /**
     * @return a new picker from a string then select the given css query
     */
    public static Picker create(String html, String cssq) {
        return new Picker(null, html, cssq);
    }


    //Create a picker for a string
    private Picker(InputStream is, String html, String cssq) {

        Element elem = null;
        Document doc = null;

        // parse
        try {
            if (is != null) {
                log.debug("parsing resource");
                doc = Jsoup.parse(is, "UTF-8", baseUrl);
            } else if (html != null) {
                log.debug("parsing string");
                doc = Jsoup.parse(html);
            }
        } catch (Exception e) {
            warn(e, "cannot parse template");
        }

        // select internally
        if (doc != null) {
            if (cssq != null) {
                log.debug("selecting " + cssq);
                elem = doc.select(cssq).first();
                if (elem == null) {
                    throw new IllegalArgumentException("cannot select " + cssq);
                }
            } else
                elem = doc;
        } else {
            throw new IllegalArgumentException("cannot load document");
        }

        // finally assign....
        bottom = elem;
        push(elem);
    }

    /**
     * @return Select a new element with a css query and return a new Picker
     * @throws Exception
     */
    public Picker select(String where) {
        Elements selected = top.select(where);
        if (selected != null && selected.size() > 0) {
            push(selected.first());
            selectOk = true;
            return this;
        } else {
            selectOk = false;
            warn(null, "cannot select " + where);
            return this;
        }
    }

    /**
     * @return a picker moved to the precedent selected element
     */
    public Picker up() {
        pop();
        return this;
    }

    /**
     * @return a picker with replaced where indicated with the specified html
     * @throws Exception
     */
    public Picker replace(String where, String what) {
        if (select(where).selectOk) {
            top.html(nn(what));
            up();
        }
        return this;
    }

    // private method to implement both single and remove
    private Picker removeOrSingle(String where, boolean keepFirst) {

        Iterator<Element> it = top.select(where).iterator();
        // keep the first
        if (keepFirst)
            if (it.hasNext())
                it.next();

        // remove others
        while (it.hasNext())
            it.next().remove();

        return this;
    }

    /**
     * @return a picker with removed the nodes specified
     */
    public Picker remove(String where) {
        return removeOrSingle(where, false);
    }

    /**
     * @return a picker with removed specified attributes
     */
    public Picker removeAttrs(String where, String... attrs) {
        for (Element el : top.select(where))
            for (String attr : attrs)
                el.attributes().remove(attr);
        return this;
    }

    /**
     * @return a picker keeping only one instance of the node specified
     */
    public Picker single(String where) {
        return removeOrSingle(where, true);
    }

    /**
     * @return a picker with emptied the specified nod
     */
    public Picker empty(String where) {
        top.select(where).empty();
        return this;
    }

    /**
     * @return a picker with emptied the current node
     */
    public Picker empty() {
        top.empty();
        return this;
    }



    private static Pattern moupat = Pattern.compile("\\{\\{(\\w+)\\}\\}");

    private static String moustache(String s, Content... contents) {
        StringBuffer sb = new StringBuffer();
        Matcher m = moupat.matcher(s);
        next:
        while (m.find()) {
            String rep = m.group(1);
            log.trace("looking for %s", rep);
            for (Content c : contents) {
                if (c.exists(rep)) {
                    String val = c.getString(rep);
                    log.trace("found %s=%s", rep, val);
                    m.appendReplacement(sb, val);
                    continue next;
                }
            }
        }
        m.appendTail(sb);
        return sb.toString();
    }

    /**
     * @return the inner html of the selected nod. Replace the content of all the
     * variables between {{ }}
     */
    public String html(Content... content) {
        return moustache(bottom.html(), content) + warnings();
    }

    /**
     * @return the same as html(...)
     */
    public String innerHtml(Content... content) {
        return html(content);
    }

    /**
     * @return the html of the selected node including the node itself
     */
    public String outerHtml(Content... content) {
        return moustache(bottom.outerHtml(), content) + warnings();
    }

    /**
     * @return a picker with added before a given node
     */
    public Picker before(String where, String what) {
        // top.select(where).parents().first().append(what);
        top.select(where).before(nn(what));
        return this;
    }

    /**
     * @return a picker with added after a given node
     */
    public Picker after(String where, String what) {
        // top.select(where).parents().first().prepend(what);
        top.select(where).after(nn(what));
        return this;
    }

    /**
     * @return a picker with appended the node as a children to the selected node.
     */
    public Picker append(String where, String what) {
        top.select(where).append(nn(what));
        return this;
    }

    /**
     * @return a  picker with appended the node as a children to the current node
     */
    public Picker append(String what) {
        top.append(nn(what));
        return this;
    }

    /**
     * @return a picker with  a attribute set
     */
    public Picker attr(String where, String attr, String what) {
        top.select(where).attr(attr, nn(what));
        return this;
    }

    /**
     * @return a picker with an attribute prefix for all the attributes found
     */
    public Picker prefixAttrs(String where, String attr, String prefix) {
        prefix = nn(prefix);
        for (Element el : top.select(where)) {
            el.attr(attr, prefix + el.attr(attr));
        }
        return this;
    }

    /**
     * @return a picker with   a class added
     */
    public Picker addClass(String where, String what) {
        top.select(where).addClass(what);
        return this;
    }

    /**
     * @return itself - fluent convenience method to dump the html of the current node - embedded calls
     * are decoded
     */
    public Picker dump(Log log) {
        if (log != null)
            log.trace(AsUtils.dumpStream(html()));
        return this;
    }

    /**
     * @return itself - fluent convenience method to dump a generic html - embedded calls are decoded.
     */
    public static void dump(Log log, String html) {
        if (log != null)
            log.trace(AsUtils.dumpStream(html));
    }

    /**
     * @return itself - fluent convenience method to dump the outer html of the current node - embedded
     * calls are decoded.
     */
    public Picker odump(Log log) {
        if (log != null)
            log.trace(AsUtils.dumpStream(outerHtml()));
        return this;
    }

    /**
     * Replace tag selected by "where" with String "What"
     *
     * @param where Selection criteria (placeholder)
     * @param what  The string to replace the "where" with, this must be valid
     *              HTML
     * @return This picker
     */
    public Picker replaceWith(String where, String what) {
        Document newTag = Jsoup.parse(what);
        Elements elements = top.select(where);
        for (Element element : elements) {
            log.trace("Replace with: %s", newTag.childNode(0).childNode(1)
                    .childNode(0));
            element.replaceWith(newTag.childNode(0).childNode(1).childNode(0));
        }
        return this;

    }

    /**
     * Print the current selected node as a string
     */
    public String toString() {
        // log.debug(doc.toString());
        return top.toString();
    }
}