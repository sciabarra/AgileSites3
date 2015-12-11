val pluginCurrentVer = "3.0.0-SNAPSHOT"

resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases"
)

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "agilesites.ver").getLines.next.trim
} catch { case _: Throwable =>  pluginCurrentVer }

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer)

//val plugin = project.in(file(".")).dependsOn((file("project")/"conf").toURI)

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "4.0.0")
