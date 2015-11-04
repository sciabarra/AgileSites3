package agilesitesng.wem.model

import org.scalatest._
import net.liftweb.json._

class WemModelSpec extends FreeSpec {

  val url = new java.net.URL("http://localhost:8080/sites")

  val file = new java.io.File("src/test/resources/Test.jsp")

  "cselement" in {
    info("===== BUILD =====")
    val json = WemCSElement.build("AdminSite", file)
    info(pretty(render(json)))
  }
}
