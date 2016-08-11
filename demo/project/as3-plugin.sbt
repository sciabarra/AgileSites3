//addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % pluginVer)

val plugin = (file("..")/"plugin").toURI

val root = project.in(file(".")).dependsOn( plugin )
