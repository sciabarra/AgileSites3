name := "AgileSites3"

organization := "com.sciabarra"

scalaVersion := "2.10.5"

resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")
assemblySettings

val ASBuilder = project.in(file("."))
    .enablePlugins(SbtWeb)
    .dependsOn(file("plugin").toURI)
        
libraryDependencies += "com.sciabarra" % "agilesites3-plugin" % "3.0.0-SNAPSHOT" extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")

compileOrder := CompileOrder.JavaThenScala

val demo = project.in(file("demo"))

val boot = project.in(file("boot"))
