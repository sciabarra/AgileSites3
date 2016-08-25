//addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % "3.11.0-M1")

val root = project.in(file(".")).dependsOn(file("plugin").toURI)

