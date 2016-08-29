val agilesitesVersion =
  scala.io.Source.fromFile("agilesites.ver").
    getLines.mkString("").trim

name := sitesFocus.value

version := {
  val javaVersion = sys.props("java.version")
  if (!javaVersion.startsWith("1.7"))
    throw new Error("ERROR! AgileSites 3.11 requires Java 1.7.x and you have " + javaVersion)
  utilPropertyMap.value.getOrElse("version", "0.1-SNAPSHOT")
}

organization := utilPropertyMap.value.getOrElse("organizaition", "com.sciabarra")

unmanagedBase := {
  val dist = sitesDirectory.value / "webapps" / "cs" / "WEB-INF" / "lib"
  if (!dist.exists) {
    println("WARNING! You need to install Sites before you do everthing else!")
    println("Hints:")
    println("- download Sites with sitesDownload")
    println("- install  Sites with sitesInstall")
    println("- generate a site for AgileSites with asNewSite")
    println("- install AgileSites with asSetup")
    println("- deploy applications with asDeploy")
  }
  dist
}

excludeFilter in unmanagedJars := "slf4j-jdk14-*.jar"

enablePlugins(AgileSitesNgPlugin)

resolvers += "agilesites3" at "https://s3.amazonaws.com/agilesites3-repo/releases"

ivyConfigurations ++= Seq(config("akkahttp"), config("core"), config("api"))

libraryDependencies ++= Seq(
  "com.sciabarra" % "agilesites3-plugin" % agilesitesVersion
    extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
  , "com.sciabarra" % "agilesites3-plugin" % agilesitesVersion % "tomcat"
    extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
  , "com.sciabarra" % "agilesites3-core" % agilesitesVersion % "core" intransitive()
  , "com.sciabarra" % "agilesites3-core" % agilesitesVersion
  , "com.sciabarra" % "agilesites3-api"  % agilesitesVersion % "api" intransitive()
  , "com.google.guava" % "guava"         % "16.0.1" % "api" intransitive()
  , "junit" % "junit"  % "4.11"          % "api" intransitive()
  , "org.hamcrest"     %  "hamcrest-core" % "1.3" % "api" intransitive()
  , "com.sciabarra" % "agilesites3-api" % agilesitesVersion
  )

libraryDependencies ++= Seq(
  "com.novocode" % "junit-interface" % "0.11" % "test"
  , "org.mockito" % "mockito-core" % "1.10.19" % "test"
)

net.virtualvoid.sbt.graph.Plugin.graphSettings

scalaVersion := "2.10.5"

javacOptions ++= Seq("-g", "-Xlint:unchecked")

crossPaths := false

compileOrder := CompileOrder.JavaThenScala

publishArtifact in(Compile, packageDoc) := false

EclipseKeys.projectFlavor := EclipseProjectFlavor.Java
