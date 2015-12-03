resolvers ++= Seq(
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots",
  "Scalaz Bintray Repo"  at "http://dl.bintray.com/scalaz/releases")

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")

val plugin = (file("..")/"plugin").toURI

val root = project.in(file(".")).dependsOn( plugin )

