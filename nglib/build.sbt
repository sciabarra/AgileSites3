val nglib = project.in(file(".")).enablePlugins(AgileSitesNgPlugin)

name := "agilesites3-nglib"

organization := "com.sciabarra"

version := "3.0.0-SNAPSHOT"

scalaVersion := "2.10.5"

crossPaths := false

libraryDependencies ++= Seq(
  "com.sciabarra" % "agilesites3-plugin" % "3.0.0-SNAPSHOT" extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13"))

libraryDependencies += "junit" % "junit" % "4.11" % "test"

watchSources ++= ((baseDirectory.value / "src" / "main" / "resources") ** "*.jsp").get

sitesPopulate := (baseDirectory.value / "src" / "main" / "resources").getAbsolutePath

ngConcatJavaMap := Map(
  (file(sitesPopulate.value) / "aaagile" / "ElementCatalog" / "AAAgileServices.txt") ->
    (baseDirectory.value / "src" / "main" / "java" / "agilesitesng" / "services" * "*.java"),
  (baseDirectory.value / "src" / "test" / "groovy" / "AAAgileServices.groovy") ->
    (baseDirectory.value / "src" / "main" / "java" / "agilesitesng" / "services" * "*.java"),
/*
  (baseDirectory.value / "src" / "test" / "groovy" / "AAAgileApi.groovy") ->
    (baseDirectory.value / "src" / "main" / "java" / "agilesitesng" / "api" * "*.java"),
*/
  (file(sitesPopulate.value) / "aaagile" / "ElementCatalog" / "AAAgileApi.txt") ->
    ((baseDirectory.value / "src" / "main" / "java" / "agilesites" / "api" * "*.java") +++
      (baseDirectory.value / "src" / "main" / s"java-${sitesVersion.value}" / "agilesites" / "api" * "*.java")))

unmanagedSourceDirectories in Compile += baseDirectory.value / "src" / "main" / s"java-${sitesVersion.value}"

unmanagedBase := file(sitesWebapp.value) / "WEB-INF" / "lib"

publishArtifact in(Compile, packageDoc) := false

publishArtifact in packageDoc := false

TaskKey[String]("snapshot") := {
  val fmt = new java.text.SimpleDateFormat("yyyy.MMdd.HHmm");
  val snapshot = fmt.format(new java.util.Date)+"-SNAPSHOT"
  IO.write(baseDirectory.value / "version.txt", snapshot)
  snapshot
}

addCommandAlias("snap", """; snapshot ; set version := scala.io.Source.fromFile("version.txt").getLines.next ; publishLocal""")
