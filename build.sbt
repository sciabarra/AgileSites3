name := "AgileSites3"

organization := "com.sciabarra"

scalaVersion := "2.10.5"

val tcv = "7.0.57"

resolvers ++=
  Seq("Local Maven" at Path.userHome.asFile.toURI.toURL + ".m2/repository"
    , "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases"
    , "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots"
  )

val deploySetup = taskKey[Unit]("deploy to bin/setup.jar")

deploySetup := {
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

RepositoryBuilder.localRepo := file("/") / "data" / "sites" / "repo" / "local"

val as = project.in(file("."))
  .enablePlugins(SbtWeb)
  .enablePlugins(AgileSitesNgPlugin)
  .settings(RepositoryBuilder.localRepoCreationSettings: _*)
  .settings(
    RepositoryBuilder.localRepoProjectsPublished <<= (publishedProjects map (publishLocal in _)).dependOn,
    RepositoryBuilder.addProjectsToRepository(publishedProjects),
    RepositoryBuilder.localRepoArtifacts ++=
      Seq("org.scala-sbt" % "sbt" % "0.13.8"
        , "org.scala-lang" % "scala-compiler" % "2.10.4" % "master"
        , "org.scala-lang" % "jline" % "2.10.4" % "master"
        , "org.fusesource.jansi" % "jansi" % "1.11" % "master"
        , "com.sciabarra" % "agilesites3-plugin" % "v3-M5-SNAPSHOT" % "run"
          extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
      )).dependsOn(file("plugin").toURI)

val nglib = project.in(file("nglib"))

val demo = project.in(file("demo"))
  .dependsOn(nglib)

val ngdemo = project.in(file("ngdemo"))
  .dependsOn(nglib)

addCommandAlias("p2", """; eval System.setProperty("profile", "12c") ; reload ; project bb""")

addCommandAlias("p1", """; eval System.setProperty("profile", "11g") ; reload ; project bb""")

addCommandAlias("r", """reload""")

addCommandAlias("bb", """project demo""")

addCommandAlias("nl", """project nglib""")

addCommandAlias("nd", """project ngdemo""")

addCommandAlias("dlib", s"""; nl; ngConcatJava ; cmov import_all aaagile; ng:service version refresh=1 debug=${(file("nglib")/"src"/"test"/"groovy"/"AAAgileServices.groovy").getAbsolutePath}; bb""")

addCommandAlias("lib", s"""; nl ; ngConcatJava ; cmov import_all aaagile; ng:service version refresh=1 ; bb""")

addCommandAlias("dbg", """set logLevel := Level.Debug""")

