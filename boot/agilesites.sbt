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

//libraryDependencies += "com.sciabarra" % "agilesites3-plugin" % pluginVer extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")

libraryDependencies ++= Seq(
    "com.sciabarra" % "agilesites3-plugin" % pluginVer extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
    , "org.mockito" % "mockito-all" % "1.10.19"
    , "org.powermock" % "powermock-core" % "1.6.4"
    , "org.powermock" % "powermock-module-junit4" % "1.6.4"
    , "org.powermock" % "powermock-api-mockito" % "1.6.4"
    , "junit" % "junit" % "4.12"
)

unmanagedBase := baseDirectory.value.getAbsoluteFile / "project" / "WEB-INF" / "lib"

addCommandAlias("dbg", """set logLevel := Level.Debug""")

name := sitesFocus.value

organization := "org.agilesites"

version := "3.0.0-SNAPSHOT"

EclipseKeys.projectFlavor := EclipseProjectFlavor.Java

ivyConfigurations += config("akkahttp") 
