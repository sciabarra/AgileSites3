val v = "11g-SNAPSHOT"

val tomcatVersion = "7.0.57"

val hsqlVersion = "1.8.0.10"

name := "AgileSites11g"

organization := "com.sciabarra"

val agilesites11g = project.in(file("."))
  .enablePlugins(SbtWeb)
  .enablePlugins(AgileSitesPlugin)
  .enablePlugins(AgileSitesJsPlugin)

def tomcatDeps(tomcatConfig: String) = Seq(
  //"org.apache.tomcat" % "tomcat-catalina" % tomcatVersion % tomcatConfig,
  "org.apache.tomcat.embed" % "tomcat-embed-core" % tomcatVersion % tomcatConfig,
  "org.apache.tomcat.embed" % "tomcat-embed-logging-juli" % tomcatVersion % tomcatConfig,
  "org.apache.tomcat.embed" % "tomcat-embed-jasper" % tomcatVersion % tomcatConfig,
  "org.apache.tomcat" % "tomcat-jasper" % tomcatVersion % tomcatConfig,
  "org.apache.tomcat" % "tomcat-jasper-el" % tomcatVersion % tomcatConfig,
  "org.apache.tomcat" % "tomcat-jsp-api" % tomcatVersion % tomcatConfig,
  "org.apache.tomcat" % "tomcat-dbcp" % tomcatVersion % tomcatConfig,
  "org.hsqldb" % "hsqldb" % hsqlVersion % tomcatConfig, // database
  "org.apache.httpcomponents" % "httpclient" % "4.3.4",
  "com.sciabarra" % "agilesites2-build" % v
    extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13") changing() intransitive())

libraryDependencies ++= tomcatDeps("compile")

resolvers ++= Seq(//"Local Maven" at Path.userHome.asFile.toURI.toURL + ".m2/repository",
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots")


val deploy = taskKey[Unit]("deploy to bin/setup.jar")

deploy := {
  // assemble startup jar
  val src = AssemblyKeys.assembly.value
  val dst = file("setup") / "bin" / "setup.jar"
  IO.copyFile(src, dst)
  println(s"+++ ${dst}")
}

assemblySettings

scalacOptions += "-feature"

scalacOptions += "-target:jvm-1.6"

javacOptions ++= Seq("-source", "1.6", "-target", "1.6")

