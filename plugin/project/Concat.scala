import sbt._, Keys._

object Concat {

 def javaConcatToGroovy(map: Map[File, PathFinder], version: String) = {

  val out = for ((output, input) <- map) yield {
    val lines = for {
      file <- input.get
      line <- scala.io.Source.fromFile(file).getLines()
    } yield line

    def removeMinus(line: String) = if (line.trim.endsWith("//-")) "\n" else line

    def deCommentPlus(line: String) = if (line.trim.startsWith("//+"))
      line.trim.substring(3) + "\n"
    else line

    val thePackage = lines.filter(_.startsWith("package ")).head.toString

    val imports = lines.filter(_.startsWith("import ")).toSeq.distinct

    val bodies = lines.filter(x => !(x.startsWith("import ") || x.startsWith("package "))).toSeq
    val helloWorld = s"Concat of ${thePackage} ${version} built on ${new java.util.Date}"
    println(output)
    output.getParentFile.mkdirs
    val fw = new java.io.FileWriter(output)
    val result = (imports ++ bodies)
      .map(removeMinus(_))
      .map(deCommentPlus(_))
      .mkString(s"${thePackage}\n\n", "\n",
        s"""
           |public class Version { public String toString() { return "${helloWorld}"; } }
        """.stripMargin)
    fw.write(result)
    fw.close
    helloWorld
  }
  map.keys.toSeq
 }

 // generating groovy for debug
 val concatTask = TaskKey[Seq[File]]("concat by compile") <<= Def.task {

  //println("%%% generating groovy & resources for debug %%%")

  val tgtG = baseDirectory.value / "src" / "test" / "groovy"
  val tgtR = baseDirectory.value / "src" / "main" / "resources" / "aaagile" / "ElementCatalog"
  val src = baseDirectory.value / "src" / "main"
  val sitesVersion = "12.1.4.0.1"

  val out = try {
    javaConcatToGroovy(Map(
      tgtG / "AAAgileServices.groovy" ->
        (src / "java" / "agilesitesng" / "services" * "*.java"),
      tgtG / "AAAgileApi.groovy" ->
        ((src / "java" / "agilesites" / "api" * "*.java") +++
          (src / s"java-${sitesVersion}" / "agilesites" / "api" * "*.java")),
      tgtG / "Api.groovy" ->
        (src / "java" / "agilesitesng" / "api" * "*.java"),
      src / "resources" / "Api.groovy" ->
        (src / "java" / "agilesitesng" / "api" * "*.java"),
      tgtR / "AAAgileServices.txt" ->
        (src / "java" / "agilesitesng" / "services" * "*.java"),
      tgtR / "AAAgileApi.txt" ->
        ((src / "java" / "agilesites" / "api" * "*.java") +++
          (src / s"java-${sitesVersion}" / "agilesites" / "api" * "*.java"))
    ), version.value)
  } catch {
    case e: Exception => e.printStackTrace()
      Seq.empty[File]
  }
  out
 }.triggeredBy(compile in Compile)
}
