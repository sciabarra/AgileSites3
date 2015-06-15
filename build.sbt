val tcv = "7.0.57"

name := "AgileSites11g"

organization := "com.sciabarra"

def tomcatDeps(tcfg: String) = Seq(
  "org.apache.tomcat.embed" % "tomcat-embed-core" % tcv % tcfg,
  "org.apache.tomcat.embed" % "tomcat-embed-logging-juli" % tcv % tcfg,
  "org.apache.tomcat.embed" % "tomcat-embed-jasper" % tcv % tcfg,
  "org.apache.tomcat" % "tomcat-jasper" % tcv % tcfg,
  "org.apache.tomcat" % "tomcat-jasper-el" % tcv % tcfg,
  "org.apache.tomcat" % "tomcat-jsp-api" % tcv % tcfg,
  "org.apache.tomcat" % "tomcat-dbcp" % tcv % tcfg,
  "org.hsqldb" % "hsqldb" % "1.8.0.10" % tcfg, // database
  "org.apache.httpcomponents" % "httpclient" % "4.3.4",
  "com.sciabarra" % "agilesites2-build" % "11g-SNAPSHOT-001" 
    extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13") changing() intransitive())

libraryDependencies ++= tomcatDeps("compile")

resolvers ++= Seq(//"Local Maven" at Path.userHome.asFile.toURI.toURL + ".m2/repository",
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
   Resolver.url("bintray-sbt-plugin-releases",
    url("http://dl.bintray.com/content/sciabarra/sbt-plugins"))(Resolver.ivyStylePatterns),
   Resolver.bintrayRepo("sciabarra", "maven"))

val deploy = taskKey[Unit]("deploy to bin/setup.jar")

deploy := {
  // assemble startup jar
  val src = AssemblyKeys.assembly.value
  val dst = file("setup") / "bin" / "setup.jar"
  IO.copyFile(src, dst)
  println(s"+++ ${dst}")
}

assemblySettings

scalacOptions ++= Seq("-feature", "-target:jvm-1.6")

javacOptions ++= Seq("-source", "1.6", "-target", "1.6")

lazy val publishedProjects = Seq[ProjectReference]()

RepositoryBuilder.localRepo :=  file("/") / "data" / "sites" / "repo" / "local"

val agilesites11g = project.in(file("."))
  .enablePlugins(SbtWeb)
  .enablePlugins(AgileSitesPlugin)
  .settings(RepositoryBuilder.localRepoCreationSettings:_*)
  .settings(
    RepositoryBuilder.localRepoProjectsPublished <<= (publishedProjects map (publishLocal in _)).dependOn,
    RepositoryBuilder.addProjectsToRepository(publishedProjects),
    RepositoryBuilder.localRepoArtifacts ++= Seq("org.scala-sbt"  % "sbt" % "0.13.8"
      ,"org.scala-lang" % "scala-compiler" % "2.10.4" % "master"
      ,"org.scala-lang" % "jline" % "2.10.4" % "master"
      ,"org.fusesource.jansi" % "jansi" % "1.11" % "master"
      ,"com.sciabarra" % "agilesites2-core" % "11.1.1.8.0_1.9a"
      ,"com.sciabarra" % "agilesites2-api" % "11.1.1.8.0_1.9a"
      ,"com.sciabarra" % "agilesites2-setup" % "2.0.3"
      ,"com.sciabarra" % "agilesites2-build" % "2.0.4" extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
      ,"org.aeonbits.owner" % "owner" % "1.0.8" % "master"
    )) 

val bb = project.in(file("bigbang"))
