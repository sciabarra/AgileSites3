package agilesitesng.deploy.spoon

import java.io.File
import spoon.Launcher
import agilesitesng.deploy.model.{Uid, Spooler}

/**
 * Created by msciab on 08/08/15.
 */
object SpoonMain extends App with SpoonUtils {


  // initialize spoon
  val out = new java.io.File(System.getProperty("spoon.spool"))
  val uid = new java.io.File(System.getProperty("uid.properties"))

  // init
  Uid.init(uid)
  SpoonPre.init()

  // run and save the spool file
  val spoon = new Launcher()
  spoon.run(args)
  writeFile(out, Spooler.save)
}
