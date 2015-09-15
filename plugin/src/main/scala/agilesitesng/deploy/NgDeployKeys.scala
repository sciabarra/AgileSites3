package agilesitesng.deploy

import akka.actor.{ActorRef, Actor}
import sbt._

/**
 * Created by msciab on 03/07/15.
 */
object NgDeployKeys {
  val ng = config("ng")
  val deploy = inputKey[Unit]("AgileSitesNg deploy")
  val spoon = inputKey[File]("invoke spoon")
  val service = inputKey[String]("invoke a service")
  val uid = taskKey[Map[String,String]]("load uids for the site")
  val sqlSelect = inputKey[String]("invoke an sql select")
  val sqlDelete = inputKey[String]("invoke an sql delete")
  val sqlInsert = inputKey[String]("invoke an sql insert")
  val sqlUpdate = inputKey[String]("invoke an sql update")
  val ngDeployHub = taskKey[ActorRef]("Actor for Deployment")
  val ngSpoonClasspath = taskKey[Seq[File]]("spoon classpath")
  val ngSpoonProcessorJars = settingKey[Seq[File]]("processors jar")
  val ngSpoonProcessors = settingKey[Seq[String]]("spoon processors")
  val ngSpoonDebug = settingKey[Boolean]("spoon debug")
}
