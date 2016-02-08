package agilesitesng.proxy

import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model.HttpRequest
import akka.http.scaladsl.server.Route
import akka.stream.ActorMaterializer
import akka.http.scaladsl.server.Directives._
import akka.stream.scaladsl.{Sink, Source}

import scala.concurrent.Await
import scala.concurrent.duration._

/**
  * The backend server, handle http requests
  */
object ProxyServer extends App {

  implicit val system = ActorSystem()
  implicit val materializer = ActorMaterializer()
  implicit val executor = system.dispatcher

  val port = args(0).toInt
  val dir = new java.io.File(args(1)).getAbsolutePath
  val url = new java.net.URL(args(2))
  val timeout = args(3).toInt
  val prefix = url.getPath.replaceAll("(^/|/$)", "")

  println(s"*** Proxy: listening in ${port}\nServing static  from ${dir}\nProxying ${prefix} to ${url}\nTimout is ${timeout} seconds\n\n")

  val exitRoute = path("-exit-from-proxy-") {
    complete {
      new Thread() {
        override def run(): Unit = {
          Thread.sleep(1000)
          println("*** Proxy: EXITING ***")
          system.shutdown()
          System.exit(0)
        }
      }.start
      "OK"
    }
  }

  val staticRoute = Route { ctx =>
    println("static: " + ctx.request.uri)
    ctx.reject()
  } ~ pathPrefix("") {
    getFromDirectory(dir)
  }

  val proxyRoute = pathPrefix(prefix / Segment) { rest =>
    val req = s"/${prefix}/${rest}"
    println(s"proxy :${req}")
    val res = Source.single(HttpRequest(uri = req))
      .via(Http(system).outgoingConnection(url.getHost, url.getPort))
      .runWith(Sink.head)
      .map(r => complete(r))
    Await.result(res, timeout.seconds)
  }

  Http().bindAndHandle(
    exitRoute ~ proxyRoute ~ staticRoute,
    "127.0.0.1", port)
}
