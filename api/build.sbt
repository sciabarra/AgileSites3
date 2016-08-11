name := "agilesites3-api"

organization := "com.sciabarra"

version := "3.11-SNAPSHOT"

scalaVersion := "2.10.5"

javacOptions ++= Seq("-g", "-Xlint:unchecked", "-source", "1.7", "-target", "1.7")

scalacOptions ++= Seq("-target:jvm-1.7")

crossPaths := false

javacOptions in Compile += "-g"

autoScalaLibrary := false

libraryDependencies ++= Seq(
     "com.sciabarra" % "agilesites3-core" % "3.11-SNAPSHOT",
     "junit" % "junit" % "4.11",
     "com.novocode" % "junit-interface" % "0.9" % "test",
     "log4j" % "log4j" % "1.2.16" % "provided")

unmanagedBase := {
  val javaVersion = sys.props("java.version")
  if(!javaVersion.startsWith("1.7"))
    throw new Error("ERROR! AgileSites 3.11 requires Java 1.7.x and you have "+javaVersion)
  val dist = baseDirectory.value.getParentFile /  "sites" / "webapps" /"cs" / "WEB-INF" / "lib"
  if(!dist.exists)
    println("WARNING! you need to install Sites with sitesInstall before you can work.")
  dist
}

sources in (Compile,doc) := Seq.empty

publishArtifact in (Compile, packageDoc) := false
