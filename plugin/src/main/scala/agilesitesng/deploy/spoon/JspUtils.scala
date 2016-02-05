package agilesitesng.deploy.spoon

/**
 * Created by msciab on 01/12/15.
 */
object JspUtils {

  def wrapAsJsp(body: String) =
    s"""<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
      |%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
      |%><%@ taglib prefix="fragment" uri="futuretense_cs/fragment.tld"
      |%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
      |%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
      |%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
      |%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
      |%><cs:ftcs><%--
      |INPUT:
      |OUTPUT:
      |--%>
      |${body}
      |</cs:ftcs>""".stripMargin
}
