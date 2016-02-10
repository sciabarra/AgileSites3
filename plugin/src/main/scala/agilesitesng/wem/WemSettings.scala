package agilesitesng.wem

import sbt._
import sbt.Keys._
import scala.concurrent.Await
import scala.concurrent.duration._
import net.liftweb.json._
import agilesites.Utils
import agilesitesng.wem.actor.Protocol
import akka.actor.ActorRef
import akka.pattern.ask
import akka.util.Timeout
import agilesites.config.AgileSitesConfigKeys.sitesTimeout
import Protocol.{Reply, Put}

/**
  * Created by msciab on 01/07/15.
  */
trait WemSettings {
  this: AutoPlugin with Utils =>

  import NgWemKeys._
  import agilesites.config.AgileSitesConfigKeys._

  def process(wem: WemFrontend, action: Symbol, args: Seq[String], log: Logger): String = {

    log.debug(s"${action.name}: ${args.mkString(" ")}")

    import Protocol._
    val inFile = """^<(.*)$""".r
    val outFile = """^>(.*)$""".r
    val req = """^(/.*)$""".r

    val m = args.map(_ match {
      case inFile(filename) => 'in -> readFile(file(filename))
      case outFile(filename) => 'out -> filename
      case req(arg) => 'arg -> arg
      case arg => println(s"ignored ${arg}")
        'ignore -> arg
    }).toMap

    log.debug(s"parsed: ${m.toString}")

    val arg = m.get('arg)
    if (arg.isEmpty) {
      s"""{ "error": "no args" }"""
    } else {

      val msg = action match {
        case 'get => Get(arg.getOrElse(""))
        case 'delete => Delete(arg.getOrElse(""))
        case 'post =>
          val json = parse(m.getOrElse('in, ""))
          println(json)
          Post(arg.getOrElse(""), json)
        case 'put =>
          val json = parse(m.getOrElse('in, ""))
          println(json)
          Put(arg.getOrElse(""), json)
      }

      log.debug(">>> sending " + msg.toString)
      val (json, status) = wem.request(msg)

      val res = if (status == 200)
        pretty(render(json))
      else
        """{ "error": "${status}" }"""
      log.debug("<<< received " + res)
      val out = m.get('out)
      if (out.isEmpty) {
        println(res)
      } else {
        writeFile(file(out.get), res, null)
        println(s"+++ ${out.get}")
      }
      res
    }
  }

  val wem = config("wem")

  def getTask = get in wem := {
    val log = streams.value.log
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val wem = new WemFrontend(new URL(sitesUrl.value), sitesUser.value, sitesPassword.value, sitesTimeout.value)
    process(wem, 'get, args, log)
  }

  def postTask = post in wem := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val wem = new WemFrontend(new URL(sitesUrl.value), sitesUser.value, sitesPassword.value, sitesTimeout.value)
    process(wem, 'post, args, streams.value.log)
  }

  def putTask = put in wem := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val wem = new WemFrontend(new URL(sitesUrl.value), sitesUser.value, sitesPassword.value, sitesTimeout.value)
    process(wem, 'put, args, streams.value.log)
  }

  def deleteTask = delete in wem := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val wem = new WemFrontend(new URL(sitesUrl.value), sitesUser.value, sitesPassword.value, sitesTimeout.value)
    process(wem, 'delete, args, streams.value.log)
  }

  val wemSettings = Seq(
    ivyConfigurations += wem,
    getTask, postTask, putTask, deleteTask)
}
