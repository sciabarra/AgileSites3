resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")

val pluginVer = "3.0.0-SNAPSHOT"

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer)

addSbtPlugin("com.typesafe.sbt" % "sbt-js-engine" % "1.1.2")

