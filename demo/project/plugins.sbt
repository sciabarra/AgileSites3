resolvers ++= Seq(
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")

val pluginVer = "3.11.0-SNAPSHOT"

//addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer)

val plugin = (file("..")/"plugin").toURI

val root = project.in(file(".")).dependsOn( plugin )
