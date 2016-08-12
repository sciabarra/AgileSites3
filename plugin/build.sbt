name := "agilesites3-plugin"

organization := "com.sciabarra"

version := "3.11-SNAPSHOT"

sbtPlugin := true

scalaVersion := "2.10.5"

isSnapshot := version.value.endsWith("-SNAPSHOT")

unmanagedSourceDirectories in Compile += baseDirectory.value / "src"/ "main" / s"java-12.1.4.0.1"

compileOrder := CompileOrder.JavaThenScala

libraryDependencies ++= Seq(
    "ch.qos.logback"             % "logback-classic"      % "1.1.3"  % "test;compile"
  , "net.openhft"                % "spoon-core"           % "4.3.0"  % "compile"
  //, "javax.servlet"            % "servlet-api"          % "2.5"    % "compile"
  //, "org.apache.tomcat.embed"    % "tomcat-embed-core"    % "7.0.59" % "compile"
  , "org.scalatest"              %% "scalatest"           % "2.2.4"  % "test"
  , "com.typesafe.akka"          %% "akka-testkit"        % "2.3.9"  % "test"
  , "com.typesafe.scala-logging" %% "scala-logging-slf4j" % "2.1.2"
  , "org.apache.httpcomponents"  %  "httpclient"          % "4.3.6"
  , "com.squareup"               %  "javapoet"            % "1.4.0"
  , "com.typesafe.akka"          %% "akka-actor"          % "2.3.9"
  , "com.typesafe.akka"          %% "akka-slf4j"          % "2.3.9"
  , "net.liftweb"                %% "lift-json"           % "2.6"
  , "io.spray"                   %% "spray-can"           % "1.3.2"
  , "io.spray"                   %% "spray-http"          % "1.3.2"
  , "io.spray"                   %% "spray-httpx"         % "1.3.2"
  , "net.databinder.dispatch"    %% "dispatch-core"       % "0.11.2"
  , "com.typesafe.akka"          %% "akka-stream-experimental"    % "2.0.3"
  , "com.typesafe.akka"          %% "akka-http-core-experimental" % "2.0.3"
  , "com.typesafe.akka"          %% "akka-http-experimental"      % "2.0.3"
  , "org.kohsuke.metainf-services" % "metainf-services"           % "1.6"
)


////////////////////////////////////
// build for java 7
javacOptions ++= Seq("-g", "-source", "1.7", "-target", "1.7", "-Xlint:unchecked")

scalacOptions ++= Seq("-feature", "-target:jvm-1.7", "-deprecation")

addSbtPlugin("com.typesafe.sbt" %% "sbt-web" % "1.2.2" exclude("org.slf4j", "slf4j-simple"))

////////////////////////////////////
// debugging
net.virtualvoid.sbt.graph.Plugin.graphSettings

// remove logback-test from jar
mappings in (Compile, packageBin) ~= { _.filter(!_._1.getName.equals("logback-test.xml")) }

mainClass := Some("agilesites.Main")

resourceGenerators in Compile <+= (resourceManaged in Compile, baseDirectory) map { (outDir: File, baseDir: File) =>
  val src = baseDir / "src" / "main" / "java" / "templates"
  val tgt = outDir / "templates"
  IO.copyDirectory(src, tgt, overwrite=true)
  IO.listFiles(tgt).toSeq
}

Seq(Concat.concatTask)

sources in (Compile,doc) := Seq.empty

publishArtifact in (Compile, packageDoc) := false

/////////////////////////////////////
//jar & generated src

unmanagedBase := {
  val javaVersion = sys.props("java.version")
  if(!javaVersion.startsWith("1.7"))
    throw new Error("ERROR! AgileSites 3.11 requires Java 1.7.x and you have "+javaVersion)
  val dist = baseDirectory.value.getParentFile /  "sites" / "webapps" / "cs" / "WEB-INF" / "lib"
  if(!dist.exists)
    throw new Error(s"ERROR! Jars not found. Plese place Sites jars under ${dist}")
  dist
}
