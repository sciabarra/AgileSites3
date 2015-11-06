name := "agilesites3-plugin"

organization := "com.sciabarra"

version := "3.0.0-SNAPSHOT"

isSnapshot := version.value.endsWith("-SNAPSHOT")

sbtPlugin := true

scalaVersion := "2.10.5"

javacOptions ++= Seq("-source", "1.6", "-target", "1.6", "-Xlint:unchecked")

scalacOptions ++= Seq("-feature", "-target:jvm-1.6", "-deprecation")

libraryDependencies ++= Seq(
    "ch.qos.logback"            % "logback-classic" % "1.1.3" % "test;compile"
  , "net.openhft"               % "spoon-core"      % "4.3.0" % "compile"
  , "javax.servlet"             % "servlet-api"     % "2.5"   % "compile"
  , "org.apache.tomcat.embed"   % "tomcat-embed-core" % "7.0.59" % "compile"
  , "org.apache.httpcomponents" % "httpclient"      % "4.3.6"
  , "com.typesafe.akka"         %% "akka-actor"     % "2.3.9"
  , "com.typesafe.akka"         %% "akka-slf4j"     % "2.3.9"
  , "com.typesafe.akka"         %% "akka-testkit"   % "2.3.9" % "test"
  , "net.liftweb"               %% "lift-json"      % "2.6"
  , "io.spray"                  %% "spray-can"      % "1.3.2"
  , "io.spray"                  %% "spray-http"     % "1.3.2"
  , "io.spray"                  %% "spray-httpx"    % "1.3.2"
  , "net.databinder.dispatch"   %% "dispatch-core"  % "0.11.2"
)

addSbtPlugin("com.typesafe.sbt" %% "sbt-web" % "1.2.2" exclude("org.slf4j", "slf4j-simple"))

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

net.virtualvoid.sbt.graph.Plugin.graphSettings

mappings in (Compile, packageBin) ~= { _.filter(!_._1.getName.equals("logback-test.xml")) }

sourceGenerators in Compile <+= (sourceManaged in Compile, baseDirectory)  map { (dir, base) =>
  val annSrc = base.getParentFile / "nglib" / "src" / "main" / "java" / "agilesites" / "annotations"
  val annTgt = dir / "agilesites" / "annotations"
  val apiSrc = base.getParentFile / "nglib" / "src" / "main" / "java" / "agilesitesng" / "api"
  val apiTgt = dir / "agilesitesng" / "api"
  //println("src="+annSrc.toString)
  //println("tgt="+annTgt.toString)
  annTgt.mkdirs
  apiTgt.mkdirs
  IO.copyDirectory(annSrc, annTgt)
  IO.copyDirectory(apiSrc, apiTgt)
  val out = annTgt * "*.java" +++ apiTgt * "*.java"
  val res = out.get
  //println(res)
  res
}

resourceGenerators in Compile <+= (resourceManaged in Compile, baseDirectory)  map { (dir, base) =>
  val resSrc = base.getParentFile / "nglib" / "src" / "main" / "resources" / "aaagile" / "ElementCatalog"
  val resTgt = dir / "aaagile" / "ElementCatalog"
  //println("src="+annSrc.toString)
  //println("tgt="+annTgt.toString)
  resTgt.mkdirs
  IO.copyDirectory(resSrc, resTgt)
  val res = resTgt * "*"
  //println(res)
  res.get
}

libraryDependencies += "org.scalatest" %% "scalatest" % "2.2.4" % "test"

libraryDependencies += "com.typesafe.scala-logging" %% "scala-logging-slf4j" % "2.1.2"

TaskKey[String]("snapshot") := {
  val fmt = new java.text.SimpleDateFormat("yyyy.MMdd.HHmm");
  val snapshot = fmt.format(new java.util.Date)+"-SNAPSHOT"
  IO.write(baseDirectory.value / "version.txt", snapshot)
  snapshot
}

addCommandAlias("snap", """; snapshot ; set version := scala.io.Source.fromFile("version.txt").getLines.next ; publishLocal""")
