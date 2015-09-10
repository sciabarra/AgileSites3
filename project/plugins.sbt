val plugin = project.in(file(".")).dependsOn(file("plugin").toURI)

libraryDependencies += "ch.qos.logback" % "logback-classic" % "1.1.3"

addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.11.2")

addSbtPlugin("com.typesafe.sbt" % "sbt-web" % "1.2.0")

// needed for bigbang
addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")
