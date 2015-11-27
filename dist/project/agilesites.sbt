resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases"
)

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "plugin/version.txt").getLines.next.trim
} catch { case _: Throwable => "3.0.0-SNAPSHOT" }

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer)

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")

val plugin = project.in(file(".")).dependsOn((file("project")/"conf").toURI)