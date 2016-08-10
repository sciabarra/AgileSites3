libraryDependencies ++=
  Seq("ch.qos.logback"  % "logback-classic" % "1.1.3" % "test;compile"
     , "org.scala-sbt"  % "scripted-plugin" % sbtVersion.value
     )

addSbtPlugin("net.virtual-void" % "sbt-dependency-graph" % "0.7.5")

