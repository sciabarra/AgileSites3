version := {
  val javaVersion = sys.props("java.version")
  if(!javaVersion.startsWith("1.7"))
    throw new Error("ERROR! AgileSites 3.11 requires Java 1.7.x and you have "+javaVersion)
  scala.io.Source.fromFile(
    baseDirectory.value.getParentFile / "agilesites.ver").
    getLines.mkString("").trim
}

unmanagedBase := {
  val dist = baseDirectory.value.getParentFile /  "sites" / "webapps" / "cs" / "WEB-INF" / "lib"
  if(!dist.exists)
    throw new Error(s"ERROR! Jars not found. Plese place Sites jars under ${dist}")
  dist
}

excludeFilter in unmanagedJars := "slf4j-*.jar" || "http*.jar"

isSnapshot := version.value.endsWith("-SNAPSHOT")

publishTo := Some("Agilesites3 repo" at s"s3://agilesites3-repo/${if(isSnapshot.value) "snapshots"  else "releases"}")

organization := "com.sciabarra"

scalaVersion := "2.10.5"

