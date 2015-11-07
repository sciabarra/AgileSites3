name := "Demo"

organization := "com.sciabarra"

version := "3.0.0"

crossPaths := false

resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")

libraryDependencies ++= Seq(
  "com.sciabarra" % "agilesites3-nglib"  % "3.0.0-SNAPSHOT",
  "com.sciabarra" % "agilesites3-plugin" % "3.0.0-SNAPSHOT"
    extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
)

val nglibVer = try {
  scala.io.Source.fromFile(file("project") / "nglib.txt").getLines.next.trim
} catch { case _: Throwable => "3.0.0-SNAPSHOT"}

libraryDependencies += "com.sciabarra" % "agilesites3-nglib" % nglibVer

unmanagedBase := file("project") / "WEB-INF" / "lib"

enablePlugins(AgileSitesNgPlugin)
