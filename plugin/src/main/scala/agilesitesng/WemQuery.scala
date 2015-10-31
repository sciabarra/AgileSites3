package agilesitesng

import agilesitesng.wem.WemFrontend
import agilesitesng.wem.actor.Protocol.Get
import akka.actor.ActorSystem
import com.typesafe.config.ConfigFactory
import com.typesafe.scalalogging.slf4j.LazyLogging
import net.liftweb.json._

/**
 * Created by msciab on 24/10/15.
 */
object WemQuery
  extends App
  with AgileSitesNgSetupSupport
  with LazyLogging {


  val config = ConfigFactory.load().getConfig("sbt-web")
  val url = new java.net.URL(config.getString("sites.url"))
  val user = config.getString("sites.user")
  val password = config.getString("sites.pass")
  val system = ActorSystem("sbt-web", config)

  try {
    val wem = new WemFrontend(system, url, user, password)
    val u = args(0)
    if (args.length == 0)
      println("usage: WemQuery <get>")
    else {
      val (cur, status) = wem.request(Get(u))
      println(pretty(render(cur)))
      println(s"${u}:${status}")
    }
    wem.quit

  } catch {
    case e: Throwable =>
      println("ops! "+e.getMessage)
  }

}
