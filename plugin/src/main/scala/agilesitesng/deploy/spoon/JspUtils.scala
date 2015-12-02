package agilesitesng.deploy.spoon

/**
 * Created by msciab on 01/12/15.
 */
object JspUtils {

  def wrapAsJsp(body: String) =
    s"""<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
      |%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
      |%><cs:ftcs><%--
      |INPUT:
      |OUTPUT:
      |--%>
      |${body}
      |</cs:ftcs>""".stripMargin
}
