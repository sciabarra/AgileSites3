val αdemoς = project.in(file("."))

scalaVersion := "2.10.5"

enablePlugins(AgileSitesNgPlugin)

unmanagedBase := baseDirectory.value.getParentFile / "dist" / "project" / "WEB-INF" / "lib"

crossPaths := false

resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "plugin" / "version.txt").getLines.next.trim
} catch { case _: Throwable => "3.0.0-SNAPSHOT"}

libraryDependencies += "com.sciabarra" % "agilesites3-plugin" % pluginVer extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")

addCommandAlias("dbg", """set logLevel := Level.Debug""")
