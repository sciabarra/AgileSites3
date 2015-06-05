val plugin = project.in(file(".")).dependsOn(file("plugin").toURI)

// resolvers += Resolver.url("sbt plugin", url("http://dl.bintray.com/content/sciabarra/sbt-plugins"))(Resolver.ivyStylePatterns) 

addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.11.2")


addSbtPlugin("com.typesafe.sbt" % "sbt-web" % "1.2.0")

