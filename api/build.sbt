name := "agilesites3-api"

javacOptions ++= Seq("-g", "-Xlint:unchecked", "-source", "1.7", "-target", "1.7")

scalacOptions ++= Seq("-target:jvm-1.7")

crossPaths := false

javacOptions in Compile += "-g"

autoScalaLibrary := false

libraryDependencies ++= Seq(
  "com.sciabarra" % "agilesites3-core" % version.value,
  "junit" % "junit" % "4.11",
  "com.novocode" % "junit-interface" % "0.9" % "test",
  "log4j" % "log4j" % "1.2.16" % "provided")

sources in(Compile, doc) := Seq.empty

publishArtifact in(Compile, packageDoc) := false

ivyConfigurations += config("akkahttp")

enablePlugins(AgileSitesNgPlugin)

asPackageTarget := Some((baseDirectory.value.getParentFile/"sites"/"shared"/"agilesites"/"agilesites3-api.jar").toURI.toString)