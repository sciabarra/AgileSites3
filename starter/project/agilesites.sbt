val agilesitesVersionURL = "https://agilesites3-repo.s3.amazonaws.com/releases/11g/agilesites.ver"

val agilesitesVersion = {
  val f = file("agilesites.ver")
  if(!f.exists) {
    val ver = scala.io.Source.fromURL(agilesitesVersionURL).getLines.next.trim
    val fw = new java.io.FileWriter(f)
    fw.write(ver)
    fw.close
  }
  scala.io.Source.fromFile(f).getLines.next.trim
}


resolvers += "agilesites3" at "https://s3.amazonaws.com/agilesites3-repo/releases"

addSbtPlugin("com.frugalmechanic" % "fm-sbt-s3-resolver" % "0.9.0")

addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "3.0.0")

addSbtPlugin("net.virtual-void" % "sbt-dependency-graph" % "0.7.5")

addSbtPlugin("com.sciabarra" % "agilesites3-plugin" % agilesitesVersion)
