//addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % "3.11.0-SNAPSHOT")

val root = project.in(file(".")).dependsOn((file("..")/"plugin").toURI)


