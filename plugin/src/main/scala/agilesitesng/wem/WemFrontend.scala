package agilesitesng.wem

import agilesitesng.wem.actor.{Protocol, Hub}
import agilesitesng.wem.actor.Protocol._
import akka.actor.ActorSystem
import net.liftweb.json._
import akka.pattern.ask
import scala.concurrent.duration._
import akka.util.Timeout
import scala.concurrent.Await

/**
 * Created by msciab on 22/10/15.
 */
class WemFrontend(system: ActorSystem,
                  url: java.net.URL,
                  user: String,
                  password: String)
/*extends Logging */ {

  implicit val timeout = Timeout(300.second)

  val hub = system.actorOf(Hub.actor(), "Hub")
  val connect = hub ? Protocol.Connect(Some(url), Some(user), Some(password))
  val base = url.toString

  val connected = try {
    Await.result(connect, timeout.duration)
    println("*** connected ***")
    true
  } catch {
    case _: Throwable => false
  }

  def request(msg: Message): (JValue, Int) = {
    if (!connected)
      (parse( s"""{ "error": "not connected"}"""), -2)
    else try {
      //println(">>> sending " + msg.toString)
      val rf = hub ? msg
      val Reply(json, status) = Await.result(rf, timeout.duration).asInstanceOf[Reply]
      if (status == 200)
        (json, status)
      else
        (parse( s"""{ "status": ${status} }"""), status)
    } catch {
      case e: Throwable =>
        val msg = s"""{ "error": "${e.getMessage().replaceAll("\"", "'").replaceAll("\\n", " ")}"}"""
        println(msg)
        (parse(msg ), -1)
    }
  }

  def quit = {
    if (connected)
      Await.result(hub ? Disconnect(), timeout.duration)
    system.shutdown()
  }
}