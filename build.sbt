name := "AgileSites11g"

organization := "com.sciabarra"

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
        , "com.sciabarra" % "agilesites2-build" % "11g-M3" % "run"
          extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
        //, "com.sciabarra" % "agilesites2-core"
        // % "11.1.1.8.0_11g-M1-SNAPSHOT" % "core;compile"
        //, "com.sciabarra" % "agilesites2-api"
        //  % "11.1.1.8.0_11g-M1-SNAPSHOT" % "core;compile"
      )).dependsOn(file("plugin").toURI)


val nl = project.in(file("nglib"))

val pluginJar = file("plugin") / "target" / "scala-2.10" / "sbt-0.13" / "agilesites2-build-11g-M4-SNAPSHOT.jar"

val nglibJar = file("nglib") / "target" / "agilesitesng-lib-11g-M4-SNAPSHOT.jar"

val bb = project.in(file("bigbang"))
  .dependsOn(nl)
  .settings(ngSpoonProcessorJars := Seq(pluginJar.getAbsoluteFile, nglibJar.getAbsoluteFile))

enablePlugins(AgileSitesNgPlugin)

addCommandAlias("p2", """; eval System.setProperty("profile", "12c") ; reload ; project bb""")

addCommandAlias("p1", """; eval System.setProperty("profile", "11g") ; reload ; project bb""")

addCommandAlias("r", """reload""")

addCommandAlias("demo", """project demo""")

addCommandAlias("nl", """project nl""")

addCommandAlias("dlib", s"""; project nl ; ngConcatJava ; cmov import_all aaagile; ng:service version refresh=1 debug=${(file("nglib")/"src"/"test"/"groovy"/"AAAgileServices.groovy").getAbsolutePath}; project bb""")

addCommandAlias("lib", s"""; project nl ; ngConcatJava ; cmov import_all aaagile; ng:service version refresh=1 ; project bb""")

addCommandAlias("dbg", """set logLevel := Level.Debug""")
