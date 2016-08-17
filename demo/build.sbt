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
  val dist = baseDirectory.value.getParentFile /  "sites" / "webapps" / "cs" / "WEB-INF" / "lib"
  if(dist.exists)
    println("WARNING! you need to install Sites with sitesInstall before you can work.")
  dist
}

crossPaths := false

compileOrder := CompileOrder.JavaThenScala

val agileSitesVer = "3.11-SNAPSHOT"

ivyConfigurations ++= Seq(config("akkahttp"), config("core"), config("api"))

libraryDependencies ++= Seq(
  "com.sciabarra" % "agilesites3-plugin" % agileSitesVer extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
  , "com.sciabarra" % "agilesites3-core" % agileSitesVer % "core"
  , "com.sciabarra" % "agilesites3-core" % agileSitesVer
  , "com.sciabarra" % "agilesites3-api" % agileSitesVer % "api"
  , "com.sciabarra" % "agilesites3-api" % agileSitesVer)


net.virtualvoid.sbt.graph.Plugin.graphSettings

publishArtifact in (Compile, packageDoc) := false

sitesDirectory := baseDirectory.value.getParentFile / "sites"

ngSpoonDebug := true