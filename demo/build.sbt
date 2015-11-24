name := utilPropertyMap.value.getOrElse("sites.focus", "Demo")

organization := utilPropertyMap.value.getOrElse("organization", "org.agilesites") 

version := utilPropertyMap.value.getOrElse("version", "1.0")

scalaVersion := "2.10.5"

libraryDependencies += "com.sciabarra" % "agilesites3-plugin" % "3.0.0-SNAPSHOT" extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13") 
unmanagedBase := file("..") / "dist" / "project" / "WEB-INF" / "lib"


resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")

val demo = project.in(file(".")).enablePlugins(AgileSitesNgPlugin)

