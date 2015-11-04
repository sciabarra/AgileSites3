name := "MySite"

organization := "my.organization"

version := "1.0"

crossPaths := false

resolvers ++= Seq(
  Resolver.file("homeivy", Path.userHome.getAbsoluteFile / ".ivy2" / "local")(Resolver.ivyStylePatterns),
  Resolver.sonatypeRepo("releases"),
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots")

val nglibVer = try {
  scala.io.Source.fromFile(file("project") / "nglib.txt").getLines.next.trim
} catch { case _: Throwable => "3.0.0-M5"}

libraryDependencies += "com.sciabarra" % "agilesites3-nglib" % nglibVer

enablePlugins(AgileSitesNgPlugin)


