package agilesitesng.deploy.spoon

import java.io.File

import agilesitesng.deploy.model.{Uid, SpoonModel, Spooler}

/**
 * Created by msciab on 18/08/15.
 */
trait SpoonUtils {

  val outdir = new java.io.File(System.getProperty("spoon.outdir"))

  def writeFileOutdir(path: String, body: String): String = {
    val pathSplit = path.split( """[\.\\/]""")
    val file = new File(outdir, pathSplit.init.mkString("", File.separator, s".${pathSplit.last}"))
    file.getParentFile.mkdirs
    writeFile(file, body)
    file.getAbsolutePath
  }

  def writeFile(file: File, body: String) = {
    //println("*** %s%s****\n".format(file.toString, body))
    if (file.getParentFile != null)
      file.getParentFile.mkdirs
    val w = new java.io.FileWriter(file)
    w.write(body)
    w.close()
  }

  def streamFile(file: File, input: java.io.InputStream) = {
    //println("*** %s%s****\n".format(file.toString, body))
    if (file.getParentFile != null)
      file.getParentFile.mkdirs
    val out = new java.io.FileOutputStream(file)
    var c = input.read()
    while (c != -1) {
      out.write(c)
      c = input.read
    }
    out.close()
  }


  def class2file(className: String) = {
    val base = new File(System.getProperty("spoon.outdir"))
    val file = new File(base, className.replace('.', File.separatorChar) + ".java")
    file.getAbsolutePath
  }

  def classes2file(path: String) = {
    val base = new File(System.getProperty("spoon.outdir"))
    val file = new File(base, path.replace('.', File.separatorChar) + ".java")
    file.getAbsolutePath
  }

  def addController(name: String, classname: String) = {
    val key = s"Controller.$classname"
    Spooler.insert(50, key,
      SpoonModel.Controller(Uid.generate(key),
        name, classname, class2file(classname)))
  }

  def addApiController(name: String, classname: String) = {
    val key = s"Controller.$classname"
    Spooler.insert(50, key,
      SpoonModel.Controller(Uid.generate(key),
        name, classname, class2file(classname)))
  }

  def orEmpty(name: String, alternative: String) =
    if (name == null || name.trim.size == 0) alternative
    else name
}
