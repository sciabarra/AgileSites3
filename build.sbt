name := "AgileSites11g"

organization := "com.sciabarra"

val tcv = "7.0.57"

libraryDependencies ++=
  Seq("org.apache.httpcomponents" % "httpclient" % "4.3.4"
     ,"org.apache.tomcat.embed" % "tomcat-embed-core" % tcv % "run;compile"
     ,"org.apache.tomcat.embed" % "tomcat-embed-logging-juli" % tcv % "run;compile"
     ,"org.apache.tomcat.embed" % "tomcat-embed-jasper" % tcv % "run;compile"
     ,"org.apache.tomcat" % "tomcat-jasper" % tcv % "run;compile"
     ,"org.apache.tomcat" % "tomcat-jasper-el" % tcv % "run;compile"
     ,"org.apache.tomcat" % "tomcat-jsp-api" % tcv % "run;compile"
     ,"org.apache.tomcat" % "tomcat-dbcp" % tcv % "run;compile"
     ,"org.hsqldb" % "hsqldb" % "1.8.0.10" % "run;compile" // database
     //,"com.sciabarra" % "agilesites2-core" % "11.1.1.8.0_11g-M1-SNAPSHOT" % "core;compile"
     //,"com.sciabarra" % "agilesites2-build" % "11g-M2-SNAPSHOT" % "run;compile"
     //   extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
     )

resolvers ++=
 Seq("Local Maven" at Path.userHome.asFile.toURI.toURL + ".m2/repository"
    ,"Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases"
    ,"Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots"
    )

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

val root = project.in(file("."))
  .enablePlugins(SbtWeb)
  .enablePlugins(AgileSitesNgPlugin)
  .settings(RepositoryBuilder.localRepoCreationSettings:_*)
  .settings(
   RepositoryBuilder.localRepoProjectsPublished <<= (publishedProjects map (publishLocal in _)).dependOn,
   RepositoryBuilder.addProjectsToRepository(publishedProjects),
   RepositoryBuilder.localRepoArtifacts ++=
    Seq("org.scala-sbt"  % "sbt" % "0.13.8"
       ,"org.scala-lang" % "scala-compiler" % "2.10.4" % "master"
       ,"org.scala-lang" % "jline" % "2.10.4" % "master"
       ,"org.fusesource.jansi" % "jansi" % "1.11" % "master"
       , "com.sciabarra" % "agilesites2-build" % "11g-M3" % "run" extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
       //, "com.sciabarra" % "agilesites2-core"
       // % "11.1.1.8.0_11g-M1-SNAPSHOT" % "core;compile"
       //, "com.sciabarra" % "agilesites2-api"
       //  % "11.1.1.8.0_11g-M1-SNAPSHOT" % "core;compile"
       )).dependsOn(file("plugin").toURI)

val bb = project.in(file("bigbang"))

val nl = project.in(file("nglib"))


// addCommandAlias("to12c", """; eval System.setProperty("profile", "12c") ; reload""")

// addCommandAlias("to11g", """; eval System.setProperty("profile", "11g") ; reload""")
