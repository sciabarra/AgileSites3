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
  val ngSpoonProcessors = settingKey[Seq[String]]("spoon processors")
  val ngSpoonDebug = settingKey[Boolean]("spoon debug")

  val spoon = inputKey[File]("invoke spoon with parameters")
  val ngSpoon = taskKey[File]("invoke spoon without parameters")
  val ngUid = taskKey[Map[String,String]]("load uids for the site")
}
