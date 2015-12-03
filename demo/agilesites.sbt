val demo = project.in(file(".")).enablePlugins(AgileSitesNgPlugin)

scalaVersion := "2.10.5"

unmanagedBase := baseDirectory.value.getParentFile / "dist" / "project" / "WEB-INF" / "lib"

crossPaths := false

resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "agilesites.ver").getLines.next.trim
} catch { case _: Throwable => "3.0.0-SNAPSHOT"}

libraryDependencies += "com.sciabarra" % "agilesites3-plugin" % pluginVer changing() extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")

addCommandAlias("dbg", """set logLevel := Level.Debug""")


name := utilPropertyMap.value.getOrElse("sites.focus", "Unnamed")

organization := utilPropertyMap.value.getOrElse("organization", "com.sciabarra")

version := utilPropertyMap.value.getOrElse("version", "1.0-SNAPSHOT")
