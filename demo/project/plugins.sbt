val agilesitesVer = "3.11.0-M1"

resolvers += "Era7 maven releases" at "https://s3-eu-west-1.amazonaws.com/releases.era7.com"

addSbtPlugin("ohnosequences" % "sbt-s3-resolver" %  agilesitesVer)

resolvers += "agilesites3" at "https://s3.amazonaws.com/agilesites3-repo/releases"

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % agilesitesVer)
