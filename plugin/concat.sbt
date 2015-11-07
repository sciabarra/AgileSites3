
resourceGenerators in Compile <+= Def.task {

  val tgt = resourceManaged.value / "aaagile" / "ElementCatalog"
  val src = baseDirectory.value.getParentFile / "nglib" / "src" / "main"
  val sitesVersion = "12.1.4.0.1"

  val map = Map(
    tgt / "AAAgileServices.txt" ->
      (src / "java" / "agilesitesng" / "services" * "*.java"),
    tgt / "AAAgileApi.txt" ->
      ((src / "java" / "agilesites" / "api" * "*.java") +++
        (src / s"java-${sitesVersion}" / "agilesites" / "api" * "*.java"))
  )

  //println(map)

  //val base = baseDirectory.value / "src" / "main" / "java" / "agilesitesng" / "core" * "*.java"
  //val out = file("src") / "main" / "resources" / "aaagile" / "ElementCatalog" / "AAAgileLib.java"

  val out = for ((output, input) <- map) yield {

    //println(input)

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
    val helloWorld = s"Concat of ${thePackage} ${version.value} built on ${new java.util.Date}"
    output.getParentFile.mkdirs
    val fw = new java.io.FileWriter(output)
    val result = (imports ++ bodies)
      .map(removeMinus(_))
      .map(deCommentPlus(_))
      .mkString(s"${thePackage}\n\n", "\n",
        s"""
           |public class Version { public String toString() { return "${helloWorld}"; } }
        """.stripMargin)
    //println(result)
    fw.write(result)
    fw.close
    helloWorld
  }

  val res = map.keys.toSeq
  println("!!!"+res)
  //out mkString "\n"
  res
}
