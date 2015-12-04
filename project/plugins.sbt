val plugin = project.in(file("plugin"))

val root = project.in(file(".")).dependsOn(file("plugin").toURI)

libraryDependencies += "ch.qos.logback" % "logback-classic" % "1.1.3"

addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.11.2")

//addSbtPlugin("com.typesafe.sbt" % "sbt-web" % "1.2.0")

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "4.0.0")

resolvers += Resolver.sonatypeRepo("public")

libraryDependencies ++=
  Seq("ch.qos.logback"  % "logback-classic" % "1.1.3" % "test;compile"
     , "org.scala-sbt"  % "scripted-plugin" % sbtVersion.value
     )

addSbtPlugin("net.virtual-void" % "sbt-dependency-graph" % "0.7.5")


