package agilesitesng.proxy

import java.io.File

import akka.actor.ActorRef
import sbt._

/**
 * Created by msciab on 02/07/15.
 */
object NgProxyKeys {
  lazy val proxyPort = settingKey[Int]("proxy port")
  lazy val proxyLocalDir = settingKey[File]("local assets")
  lazy val proxyRemoteUrl = settingKey[URL]("remote url")
  lazy val proxy = inputKey[Unit]("Stop Local Proxy")
  lazy val proxyClasspath = taskKey[Seq[File]]("Proxy Classpath")
  lazy val proxyTimeout = settingKey[Int]("Proxy Timeout")
}
