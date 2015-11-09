val ας = project.in(file("."))

name := "Demo"

organization := "com.sciabarra"

version := "3.0.0"

crossPaths := false

resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "plugin" / "version.txt").getLines.next.trim
} catch { case _: Throwable => "3.0.0-SNAPSHOT"}

libraryDependencies +=
  "com.sciabarra" % "agilesites3-plugin" % pluginVer extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")

unmanagedBase := file("project") / "WEB-INF" / "lib"

enablePlugins(AgileSitesNgPlugin)


addCommandAlias("dbg", """set logLevel := Level.Debug""")