package agilesitesng.static

import java.io.{FilenameFilter, File}
import agilesitesng.static.NgStaticKeys._
import sbt.AutoPlugin

/**
  * Created by msciab on 10/02/16.
  */
trait StaticSettings {
  this: AutoPlugin =>

  def listAssets(base: File, filter: FilenameFilter): Seq[File] = {
    //println("listAssets: " + base)
    if (base.isDirectory) {
      val level = for {
        file <- base.listFiles(filter)
      } yield {
        //println(">" + file.getAbsolutePath)
        if (file.isDirectory)
          listAssets(file, filter)
        else Seq(file)
      }
      level.flatten.toSeq
    } else {
      Seq(base)
    }
  }

  val staticFilesTask = staticFiles := {

    val extensions = staticExtensions.value.map(_.toLowerCase).toSet

    val filenameFilter = new FilenameFilter {
      override def accept(dir: File, name: String): Boolean = {
        val ext = name.split("\\.").last.toLowerCase
        var res = new File(dir, name).isDirectory || extensions.contains(ext)
        // println(name + " " + ext + " in " + extensions + " :" + res)
        res
      }
    }
    val baseDir = staticAssetDir.value
    val len = baseDir.getAbsolutePath.length
    listAssets(baseDir, filenameFilter).
      map(x => x.getAbsolutePath.substring(len))
  }

  val staticImportTask = staticImport := {
    for(file <- staticFiles.value) {
      println(file)
    }
  }
}
