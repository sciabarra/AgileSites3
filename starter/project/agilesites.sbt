val agilesitesVersion =
  scala.io.Source.fromFile("agilesites.ver").
    getLines.mkString("").trim

resolvers += "agilesites3" at "https://s3.amazonaws.com/agilesites3-repo/releases"

addSbtPlugin("com.frugalmechanic" % "fm-sbt-s3-resolver" % "0.9.0")

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")

addSbtPlugin("net.virtual-void" % "sbt-dependency-graph" % "0.7.5")

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % agilesitesVersion)

