package agilesitesng.deploy.spoon

import java.util.Properties
import java.io.File

/**
 * Created by msciab on 25/11/15.
 */
class SpoonPre extends SpoonUtils {
  /* nice try :(
  val prp = new Properties
  prp.load(this.getClass.getClassLoader.getResourceAsStream("/spoon.properties"))

  println(prp)

  val templates = prp.getProperty("templates").split(",")
  val templateDir = new java.io.File(prp.getProperty("target"))

  def extractTemplates(): Unit = {
    for (template <- templates) {
      val file = new java.io.File(templateDir, template.replace('/', java.io.File.separatorChar))
      val stream = this.getClass.getResourceAsStream(template)
      println("writing "+file)
      SpoonMain.streamFile(file, stream)
    }
  }*/

  def preSpoon(): Unit = {
    val file = new File(System.getProperty("spoon.templates"))
    println("Extracting templates...")
    Templates.extractTemplates(file)
  }
}

object SpoonPre {
  def init() = {
    new SpoonPre().preSpoon()
  }
}