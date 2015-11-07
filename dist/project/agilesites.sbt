resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases"
)

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "plugin.txt").getLines.next.trim
} catch { case _: Throwable => "3.0.0-SNAPSHOT"}

val conf = if(sys.props.get("agilesites.plugin.source").isEmpty) {
            project.in(file(".")).dependsOn((file("project") / "conf") .toURI)
	   } else {
  	     project.in(file(".")).dependsOn((file(sys.props("agilesites.plugin.source"))).toURI)
     }


if(sys.props.get("agilesites.plugin.source").isEmpty)
  addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer)
else


addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")


