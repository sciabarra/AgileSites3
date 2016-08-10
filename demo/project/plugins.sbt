addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")

val pluginVer = "3.11.0-SNAPSHOT"

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer)

//val plugin = (file("..")/"plugin").toURI

//val root = project.in(file(".")).dependsOn( plugin )

addSbtPlugin("net.virtual-void" % "sbt-dependency-graph" % "0.7.5")

