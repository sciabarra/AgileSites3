package agilesitesng.preprocess

import agilesites.api.{Api, Log, Content, Picker, PickerInjector}
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.jsoup.nodes.Element
import org.jsoup.select.Elements
import java.util.Iterator
import java.util.Stack
import java.io.{FileInputStream, File, InputStream}
import agilesites.api.Api.nn

class PickerImpl extends Picker {

  private var _warnings: StringBuffer = new StringBuffer
  private var stack: Stack[Element] = new Stack[Element]
  private var top: Element = null
  private var bottom: Element = null
  private var selectOk: Boolean = false

  private def warn(ex: Exception, warning: String) {
    _warnings.append("<li>").append(warning)
    if (ex != null) _warnings.append("<blockquote><pre>").append(Api.ex2str(ex)).append("</pre></blockquote>")
    _warnings.append("</li>")
    PickerImpl.log.warn(warning)
  }

  private def warnings: String = {
    if (_warnings.length > 0) {
      return "<ol style='font-color: red'>" + _warnings.toString + "</ol>"
    }
    else {
      return ""
    }
  }

  private def push(elem: Element) {
    stack.push(elem)
    top = elem
  }

  private def pop {
    stack.pop
    top = stack.lastElement
  }

  protected def this(is: InputStream, html: String, cssq: String) {
    this()
    var elem: Element = null
    var doc: Document = null
    try {
      if (is != null) {
        PickerImpl.log.debug("parsing resource")
        doc = Jsoup.parse(is, "UTF-8", PickerImpl.baseUrl)
      }
      else if (html != null) {
        PickerImpl.log.debug("parsing string")
        doc = Jsoup.parse(html)
      }
    }
    catch {
      case e: Exception => {
        warn(e, "cannot parse template")
      }
    }
    if (doc != null) {
      if (cssq != null) {
        PickerImpl.log.debug("selecting " + cssq)
        elem = doc.select(cssq).first
        if (elem == null) {
          throw new IllegalArgumentException("cannot select " + cssq)
        }
      }
      else elem = doc
    }
    else {
      throw new IllegalArgumentException("cannot load document")
    }
    bottom = elem
    push(elem)
  }

  /**
   * @return Select a new element with a css query and return a new PickerImp
   * @throws Exception
   */
  def select(where: String): Picker = {
    val selected: Elements = top.select(where)
    if (selected != null && selected.size > 0) {
      push(selected.first)
      selectOk = true
      return this
    }
    else {
      selectOk = false
      warn(null, "cannot select " + where)
      return this
    }
  }

  /**
   * @return a PickerImp moved to the precedent selected element
   */
  def up: Picker = {
    pop
    return this
  }

  /**
   * @return an helper to inject data for a replacement
   */
  def replace(where: String, what: String): Picker = {
    if (select(where).asInstanceOf[PickerImpl].selectOk) {
      top.html(nn(what))
      up
    }
    return this
  }

  private def removeOrSingle(where: String, keepFirst: Boolean): PickerImpl = {
    val it: Iterator[Element] = top.select(where).iterator
    if (keepFirst) if (it.hasNext) it.next
    while (it.hasNext) it.next.remove
    return this
  }

  /**
   * @return a PickerImp with removed the nodes specified
   */
  def remove(where: String): Picker = {
    return removeOrSingle(where, false)
  }

  /**
   * @return a PickerImp with removed specified attributes
   */
  def removeAttrs(where: String, attrs: String*): Picker = {
    import scala.collection.JavaConversions._
    for (el <- top.select(where))
      for (attr <- attrs)
        el.attributes.remove(attr)
    return this
  }

  /**
   * @return a Picker keeping only one instance of the node specified
   */
  def single(where: String): Picker = {
    return removeOrSingle(where, true)
  }

  /**
   * @return a Picker with emptied the specified nod
   */
  def empty(where: String): Picker = {
    top.select(where).empty
    return this
  }

  /**
   * @return a PickerImp with emptied the current node
   */
  def empty: Picker = {
    top.empty
    return this
  }

  /**
   * @return the inner html of the selected nod. Replace the content of all the
   *         variables between {{ }}
   */
  def html(content: Content*): String = {
    // TO REDO
    //return PickerImp.moustache(bottom.html, content: _*) + warnings
    return bottom.html + warnings.toString
  }

  /**
   * @return the same as html(...)
   */
  def innerHtml(content: Content*): String = {
    return html(content: _*)
  }

  /**
   * @return the html of the selected node including the node itself
   */
  def outerHtml(content: Content*): String = {
    //return PickerImp.moustache(bottom.outerHtml, content: _*) + warnings
    return bottom.outerHtml + warnings
  }

  /**
   * @return a PickerImp with added before a given node
   */
  def before(where: String, what: String): Picker = {
    top.select(where).before(nn(what))
    return this
  }

  /**
   * @return a PickerImp with added after a given node
   */
  def after(where: String, what: String): Picker = {
    top.select(where).after(nn(what))
    return this
  }

  /**
   * @return a Picker with appended the node as a children to the selected node.
   */
  def append(where: String, what: String): Picker = {
    top.select(where).append(nn(what))
    return this
  }

  /**
   * @return a Picker with appended the node as a children to the current node
   */
  def append(what: String): Picker = {
    top.append(nn(what))
    return this
  }

  /**
   * @return a Picker with an attribute set
   */
  def attr(where: String, attr: String, what: String): PickerImpl = {
    top.select(where).attr(attr, nn(what))
    return this
  }

  /**
   * @return a Picker with an attribute prefix for all the attributes found
   */
  def prefixAttrs(where: String, attr: String, prefix: String): PickerImpl = {
    val _prefix = if (prefix == null) "" else prefix
    import scala.collection.JavaConversions._
    for (el <- top.select(where)) {
      el.attr(attr, _prefix + el.attr(attr))
    }
    return this
  }

  /**
   * @return a PickerImp with   a class added
   */
  def addClass(where: String, what: String): Picker = {
    top.select(where).addClass(what)
    return this
  }


  /**
   * Replace tag selected by "where" with String "what"
   *
   * @param where Selection criteria (placeholder)
   * @param what  The string to replace the "where" with, this must be valid
   *              HTML
   * @return This PickerImp
   */
  def replaceWith(where: String, what: String): Picker = {
    val newTag: Document = Jsoup.parse(what)
    val elements: Elements = top.select(where)
    import scala.collection.JavaConversions._
    for (element <- elements) {
      PickerImpl.log.trace("Replace with: %s", newTag.childNode(0).childNode(1).childNode(0))
      element.replaceWith(newTag.childNode(0).childNode(1).childNode(0))
    }
    return this
  }

  /**
   * @return  an injector for a "replace" call
   */
  def replace(where: String): PickerInjector = {
    return new PickerInjectorImpl(PickerInjectorImpl.REPLACE, where)
  }

  /**
   * @return  an injector for a "after" call
   */
  def after(where: String): PickerInjector = {
    return new PickerInjectorImpl(PickerInjectorImpl.AFTER, where)
  }

  /**
   * @return  an injector for a "before" call
   */
  def before(where: String): PickerInjector = {
    return new PickerInjectorImpl(PickerInjectorImpl.BEFORE, where)
  }

  /**
   * @return  an injector for a "attr" call
   */
  def attr(where: String, attr: String): PickerInjector = {
    return new PickerInjectorImpl(PickerInjectorImpl.ATTR, where, attr)
  }

  /**
   * @return  an injector for a "append" call
   */
  def append: PickerInjector = {
    return new PickerInjectorImpl(PickerInjectorImpl.APPEND)
  }

  /**
   * Print the current selected node as a string
   */
  override def toString: String = {
    return top.toString
  }
}

/**
 * PickerImp is a template engine building html pages or snippets using
 * replacements and modifications in the html with jQuery-style selectors.
 *
 * @author msciab
 */
object PickerImpl {
  private var log: Log = Log.getLog(classOf[PickerImpl])

  private val baseUrl: String = "http://localhost:8080/"

  private val assets = new java.io.File(System.getProperty("spoon.assets"))

  /**
   * @return a new PickerImp from a given resource in the classpath selected with a css query
   */
  def load(resource: String, cssq: String): PickerImpl = {
    val file = new File(assets, resource.replace('/', File.separatorChar).replace('\\', File.separatorChar))
    if (cssq == null || cssq.trim.size == 0)
      new PickerImpl(new FileInputStream(file), null, null)
    else
      new PickerImpl(new FileInputStream(file), null, null)
  }

  /**
   * @return a new PickerImp from a string
   */
  def create(html: String): PickerImpl = {
    return new PickerImpl(null, html, null)
  }

  /**
   * @return a new PickerImp from a string then select the given css query
   */
  def create(html: String, cssq: String): PickerImpl = {
    return new PickerImpl(null, html, cssq)
  }

  /*
  TO REDO!
    private var moupat: Pattern = Pattern.compile("\\{\\{(\\w+)\\}\\}")

    private def moustache(s: String, contents: Content*): String = {

      val sb: StringBuffer = new StringBuffer
      val m: Matcher = moupat.matcher(s)
      while (m.find) {
        val rep: String = m.group(1)
        log.trace("looking for %s", rep)
        for (c <- contents) {
          if (c.exists(rep)) {
            val `val`: String = c.getString(rep)
            log.trace("found %s=%s", rep, `val`)
            m.appendReplacement(sb, `val`)
            //continue //todo: continue is not supported
          }
        }
      } //todo: labels is not supported
      m.appendTail(sb)
      return sb.toString
    }
  */

  //def call(what: String) = s"<p>TODO call ${what}</p>"

}
