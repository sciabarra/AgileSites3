////////////////////////////////////
// naming

name := "agilesites3-plugin"

organization := "com.sciabarra"

version := "3.0.0-SNAPSHOT"

sbtPlugin := true

scalaVersion := "2.10.5"

isSnapshot := version.value.endsWith("-SNAPSHOT")


/////////////////////////////////////
//jar & generated src


unmanagedBase := {
  val dist = baseDirectory.value.getParentFile / "dist" / "project" / "WEB-INF" / "lib"
   val fallback = baseDirectory.value.getParentFile / "WEB-INF" / "lib"
   if(dist.exists) dist else {
      if(!fallback.exists) {
	println(s"ERROR! Jars not found. Plese place Sites WEB-INF/lib in ${fallback}")
      }
      fallback
   }
}

unmanagedSourceDirectories in Compile += baseDirectory.value / "src"/ "main" / s"java-12.1.4.0.1"

////////////////////////////////////
// dependencies

libraryDependencies ++= Seq(
    "ch.qos.logback"             % "logback-classic"      % "1.1.3" % "test;compile"
  , "net.openhft"                % "spoon-core"           % "4.3.0" % "compile"
  , "javax.servlet"              % "servlet-api"          % "2.5"   % "compile"
  , "org.apache.tomcat.embed"    % "tomcat-embed-core"    % "7.0.59" % "compile"
  , "org.apache.httpcomponents"  % "httpclient"           % "4.3.6"
  , "org.kohsuke.metainf-services" % "metainf-services"   % "1.6"
  , "com.squareup"               % "javapoet"             % "1.4.0"
  , "com.typesafe.akka"          %% "akka-actor"          % "2.3.9"
  , "com.typesafe.akka"          %% "akka-slf4j"          % "2.3.9"
  , "com.typesafe.akka"          %% "akka-testkit"        % "2.3.9" % "test"
  , "net.liftweb"                %% "lift-json"           % "2.6"
  , "io.spray"                   %% "spray-can"           % "1.3.2"
  , "io.spray"                   %% "spray-http"          % "1.3.2"
  , "io.spray"                   %% "spray-httpx"         % "1.3.2"
  , "net.databinder.dispatch"    %% "dispatch-core"       % "0.11.2"
  , "org.scalatest"              %% "scalatest"           % "2.2.4" % "test"
  , "com.typesafe.scala-logging" %% "scala-logging-slf4j" % "2.1.2"
)

addSbtPlugin("com.typesafe.sbt" %% "sbt-web" % "1.2.2" exclude("org.slf4j", "slf4j-simple"))

////////////////////////////////////
// publishing

pomIncludeRepository := { _ => false }

publishMavenStyle := true

publishTo := {
    val nexus = "http://nexus.sciabarra.com/"
    if (isSnapshot.value)
      Some("snapshots" at nexus + "content/repositories/snapshots")
    else
      Some("releases"  at nexus + "content/repositories/releases")
  }

publishArtifact in Test := false

publishArtifact in packageDoc := false

licenses += ("Apache-2.0", url("http://www.apache.org/licenses/LICENSE-2.0.html"))

credentials += Credentials(Path.userHome / ".ivy2" / "credentials")

resolvers ++= Seq(Resolver.sonatypeRepo("releases"),
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots")


////////////////////////////////////
// build for java 7
javacOptions ++= Seq("-g", "-source", "1.8", "-target", "1.8", "-Xlint:unchecked")

scalacOptions ++= Seq("-feature", "-target:jvm-1.7", "-deprecation")

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


