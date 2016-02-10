val pluginCurrentVer = "3.0.0-SNAPSHOT"

val agilesites = project.in(file("."))

scalaVersion := "2.10.5"

enablePlugins(AgileSitesNgPlugin)

javacOptions ++= Seq("-s", s"${(sourceManaged in Compile).value}", "-g", "-Xlint:unchecked")//, "-J-Xdebug", "-J-Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5006")

crossPaths := false

resolvers ++= Seq(
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases"
   //,"Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
   //,"Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots"
   )

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "plugin" / "version.txt").getLines.next.trim
} catch { case _ : Throwable => "3.0.0-SNAPSHOT" }

libraryDependencies += "com.sciabarra" % "agilesites3-plugin" % pluginVer extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")

unmanagedBase := baseDirectory.value.getAbsoluteFile / "project" / "WEB-INF" / "lib"

addCommandAlias("dbg", """set logLevel := Level.Debug""")

name := sitesFocus.value

organization := "org.agilesites"

version := "3.0.0-SNAPSHOT"

EclipseKeys.projectFlavor := EclipseProjectFlavor.Java

ivyConfigurations += config("akkahttp") 
