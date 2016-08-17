package agilesites

import sbt._, Keys._

/**
  * Created by msciab on 13/08/15.
  */
object AgileSitesConstants {

  val akkaHttpVersion = "2.0.3"

  val tomcatVersion = "7.0.70"

  val agilesitesVersion = "3.11-SNAPSHOT"

  val agilesitesPlugin = "com.sciabarra" % "agilesites3-plugin" % agilesitesVersion extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")

  val spoonDependencies = Seq(
    //"net.openhft" % "spoon-core" % "4.3.0" % "spoon"
    "fr.inria.gforge.spoon" % "spoon-core" % "4.3.0" % "spoon"
    , "commons-io" % "commons-io" % "1.3.2" % "spoon"
    , "org.scala-lang" % "scala-library" % "2.10.5" % "spoon"
    , "net.liftweb" % "lift-json_2.10" % "2.6" % "spoon"
    , "ch.qos.logback" % "logback-classic" % "1.1.3" % "spoon"
    , "com.google.guava" % "guava" % "16.0.1"
  )

  val tomcatDependencies = Seq("org.hsqldb" % "hsqldb" % "1.8.0.10"
    , "javax.servlet" % "javax.servlet-api" % "3.0.1"
    , "org.apache.tomcat.embed" % "tomcat-embed-core" % tomcatVersion
    , "org.apache.tomcat.embed" % "tomcat-embed-logging-juli" % tomcatVersion
    , "org.apache.tomcat.embed" % "tomcat-embed-jasper" % tomcatVersion
    , "org.apache.tomcat" % "tomcat-jasper" % tomcatVersion
    , "org.apache.tomcat" % "tomcat-jasper-el" % tomcatVersion
    , "org.apache.tomcat" % "tomcat-jsp-api" % tomcatVersion
    , "org.apache.tomcat" % "tomcat-dbcp" % tomcatVersion
  ) :+ agilesitesPlugin

  val akkaHttpDependencies = Seq(
    "com.typesafe.akka" % "akka-stream-experimental_2.10" % akkaHttpVersion
    , "com.typesafe.akka" % "akka-http-core-experimental_2.10" % akkaHttpVersion
    , "com.typesafe.akka" % "akka-http-experimental_2.10" % akkaHttpVersion
  ) :+ agilesitesPlugin

}
