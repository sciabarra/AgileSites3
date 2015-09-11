ngSpoonProcessorJars := Seq(
  baseDirectory.value.getParentFile / "plugin" / "src" / "main" / "resources",
  baseDirectory.value.getParentFile / "plugin" / "target" / "scala-2.10" / "sbt-0.13" / "agilesites3-plugin-v3-M5-SNAPSHOT.jar",
  baseDirectory.value.getParentFile / "nglib"  / "target" / "agilesites3-lib-v3-M5-SNAPSHOT.jar"
).map(_.getAbsoluteFile)
