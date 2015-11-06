resolvers ++= Seq(
   Resolver.file("homeivy", Path.userHome.getAbsoluteFile / ".ivy2" / "local")(Resolver.ivyStylePatterns),
   Resolver.sonatypeRepo("releases"),
  "Nexus-sciabarra-releases" at "http://nexus.sciabarra.com/content/repositories/releases",
  "Nexus-sciabarra-snapshots" at "http://nexus.sciabarra.com/content/repositories/snapshots")

val pluginVer = try {
  scala.io.Source.fromFile(file("project") / "plugin.txt").getLines.next.trim
} catch { case _: Throwable => "3.0.0-SNAPSHOT"}

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer  )

//addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")


