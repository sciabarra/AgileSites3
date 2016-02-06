package agilesitesng.proxy

import java.io.File

import agilesites.Utils
import sbt._

/**
  * Created by msciab on 05/02/16.
  */
trait ProxySettings extends Utils {
  this: AutoPlugin =>

  import NgProxyKeys._

  val proxyTask = proxy := {

    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val usage = "usage: proxy [start|stop]"

    if (args.size == 0) {
      println(usage)
    } else if (args(0) == "stop") {
      println("proxy: stopping")
      println(httpCallRaw(s"http://127.0.0.1:${proxyPort.value}/-exit-from-proxy-"))
    } else if(args(0) == "start") {
      println("proxy: starting")
      val port = proxyPort.value.toString
      val local = proxyLocalDir.value.getAbsolutePath
      val remote = proxyRemoteUrl.value.toString
      val jars = proxyClasspath.value
      val timeout = proxyTimeout.value
      val args = Seq("agilesitesng.proxy.ProxyServer", port, local, remote, timeout.toString)
      val opts = "-cp" :: jars.map(_.getAbsolutePath).mkString(File.pathSeparator) :: Nil

      //println("java " +(opts ++ args)mkString(" "))

      val fork = ForkOptions(
        runJVMOptions = opts,
        outputStrategy = Some(StdoutOutput)
      )

      val thread = new Thread() {
        override def run(): Unit = {
          println(s"Starting Server with Proxy in port ${port}\nLocal dir: ${local}\nRemote url: ${remote}")
          Fork.java(fork, args)
        }
      }
      thread.start
    } else {
      println(usage)
    }
  }
}
