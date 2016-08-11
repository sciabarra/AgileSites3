name := utilPropertyMap.value.getOrElse("sites.focus", "Installing")

organization := utilPropertyMap.value.getOrElse("organization", "com.sciabarra")

version := utilPropertyMap.value.getOrElse("version", "1.0-SNAPSHOT")

val demo = project.in(file(".")).enablePlugins(AgileSitesNgPlugin)

scalaVersion := "2.10.5"

javacOptions ++= Seq("-g", "-Xlint:unchecked")

unmanagedBase := {
  val javaVersion = sys.props("java.version")
  if(!javaVersion.startsWith("1.7"))
    throw new Error("ERROR! AgileSites 3.11 requires Java 1.7.x and you have "+javaVersion)
  val dist = baseDirectory.value.getParentFile /  "sites" / "cs" / "WEB-INF" / "lib"
  if(dist.exists)
    println("WARNING! you need to install Sites with sitesInstall before you can work.")
  dist
}

crossPaths := false

val pluginVer = "3.11-SNAPSHOT"

libraryDependencies += "com.sciabarra" % "agilesites3-plugin" % pluginVer extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")

ivyConfigurations += config("akkahttp")

net.virtualvoid.sbt.graph.Plugin.graphSettings


sitesDirectory := baseDirectory.value.getParentFile / "sites"
