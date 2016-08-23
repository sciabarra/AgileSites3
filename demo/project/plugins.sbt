val agilesitesVer = "3.11.0-M3-SNAPSHOT"

resolvers += "agilesites3" at "https://s3.amazonaws.com/agilesites3-repo/releases"

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % agilesitesVer)
