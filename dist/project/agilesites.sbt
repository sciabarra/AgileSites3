resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases"
)

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "plugin/version.txt").getLines.next.trim
} catch { case _: Throwable => "3.0.0-SNAPSHOT" }

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer)

val conf = project.in(file(".")).dependsOn((file("project") / "conf") .toURI)

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")


/***
   val conf = if(sys.props.get("use.the.source.luke").isEmpty) {
      project.in(file(".")).dependsOn((file("project") / "conf") .toURI)
	 } else {
  	  project.in(file(".")).dependsOn((file(sys.props("use.the.source.luke"))).toURI)
   }
  ***/