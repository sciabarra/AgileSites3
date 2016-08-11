name := "agilesites3-core"

organization := "com.sciabarra"

version := "3.11-SNAPSHOT"

scalaVersion := "2.10.5"

crossPaths := false

autoScalaLibrary := false

javacOptions ++= Seq("-g", "-Xlint:unchecked", "-source", "1.7", "-target", "1.7")

scalacOptions ++= Seq("-target:jvm-1.7")

libraryDependencies ++= Seq(
       "javax.servlet" % "servlet-api" % "2.5" % "provided",
       "log4j" % "log4j" % "1.2.16" % "provided",
       "commons-io" % "commons-io" % "1.4"
)

unmanagedBase := {
       val javaVersion = sys.props("java.version")
       if(!javaVersion.startsWith("1.7"))
              throw new Error("ERROR! AgileSites 3.11 requires Java 1.7.x and you have "+javaVersion)
       val dist = baseDirectory.value.getParentFile /  "sites" / "webapps" / "cs" / "WEB-INF" / "lib"
       if(!dist.exists)
              println("WARNING! you need to install Sites with sitesInstall before you can work.")
       dist
}

sources in (Compile,doc) := Seq.empty

publishArtifact in (Compile, packageDoc) := false

enablePlugins(AgileSitesPlugin)