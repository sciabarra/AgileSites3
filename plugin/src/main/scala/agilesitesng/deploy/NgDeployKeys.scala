package agilesitesng.deploy

import akka.actor.{ActorRef, Actor}
import sbt._

/**
 * Created by msciab on 03/07/15.
 */
object NgDeployKeys {
  val ng = config("ng")
  val sqlSelect = inputKey[String]("invoke an sql select")
  val sqlDelete = inputKey[String]("invoke an sql delete")
  val sqlInsert = inputKey[String]("invoke an sql insert")
  val sqlUpdate = inputKey[String]("invoke an sql update")
  val ngSpoonClasspath = taskKey[Seq[File]]("spoon classpath")
  val ngSpoonProcessorJars = settingKey[Seq[File]]("processors jar")
  val ngSpoonProcessors = settingKey[Seq[String]]("spoon processors")
  val ngSpoonDebug = settingKey[Boolean]("spoon debug")

  val spoon = inputKey[File]("invoke spoon with parameters")
  val ngSpoon = taskKey[File]("invoke spoon without parameters")
  val ngDeployHub = taskKey[ActorRef]("Actor for Deployment")
  val service = inputKey[String]("invoke a service via akka")
  val deploy = inputKey[Unit]("AgileSitesNg deploy")
  val ngUid = taskKey[Map[String,String]]("load uids for the site")
  val ngService = inputKey[String]("invoke service via http")
}
