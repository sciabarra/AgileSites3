name := "AgileSites3"

organization := "com.sciabarra"

scalaVersion := "2.10.5"

val tcv = "7.0.57"

resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")
assemblySettings

lazy val publishedProjects = Seq[ProjectReference]()

RepositoryBuilder.localRepo := file("dist" / "project" / "repo" / "local"

val ASBuilder = project.in(file("."))
  .enablePlugins(SbtWeb)
  .settings(RepositoryBuilder.localRepoCreationSettings: _*)
  .settings(
    RepositoryBuilder.localRepoProjectsPublished <<= (publishedProjects map (publishLocal in _)).dependOn,
    RepositoryBuilder.addProjectsToRepository(publishedProjects),
    RepositoryBuilder.localRepoArtifacts ++=
      Seq("org.scala-sbt" % "sbt" % "0.13.9"
        , "org.scala-lang" % "scala-compiler" % "2.10.4" % "master"
        , "org.scala-lang" % "jline" % "2.10.4" % "master"
        , "org.fusesource.jansi" % "jansi" % "1.11" % "master"
        , "com.sciabarra" % "agilesites3-plugin" % "3.0.0-SNAPSHOT" extra("scalaVersion" -> "2.10", "sbtVersion" -> "0.13")
      )).dependsOn(file("plugin").toURI)

