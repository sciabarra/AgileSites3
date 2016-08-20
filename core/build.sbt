name := "agilesites3-core"

crossPaths := false

autoScalaLibrary := false

javacOptions ++= Seq("-g", "-Xlint:unchecked", "-source", "1.7", "-target", "1.7")

scalacOptions ++= Seq("-target:jvm-1.7")

libraryDependencies ++= Seq(
       "javax.servlet" % "servlet-api" % "2.5" % "provided"
       ,"log4j" % "log4j" % "1.2.16" % "provided"
       ,"commons-io" % "commons-io" % "1.4" % "provided"
)

sources in (Compile,doc) := Seq.empty

publishArtifact in (Compile, packageDoc) := false

enablePlugins(AgileSitesPlugin)


