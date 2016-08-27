package agilesitesng.wem

import agilesites.Utils
import agilesites.config.AgileSitesConfigKeys
import agilesites.setup.AgileSitesSetupKeys
import sbt._, Keys._

import scala.util.Try

/**
  * Created by msciab on 25/08/16.
  */
trait WemImportSettings extends Utils {
  this: AutoPlugin =>

  import NgWemKeys._
  import AgileSitesSetupKeys._
  import AgileSitesConfigKeys._

  val importCmd = Command.args("asImport", "<asset-types>") {
    (state, args) =>
      val extracted: Extracted = Project.extract(state)
      val base = (baseDirectory in extracted.currentRef get extracted.structure.data).get
      val site = (sitesFocus in extracted.currentRef get extracted.structure.data).get
      val url = (sitesUrl in extracted.currentRef get extracted.structure.data).get
      val content = base / "src" / "main" / "content"
      if (helloSites(url).nonEmpty) {
        val files = (content ** "*.json").get
        val cmds = files.filter {
          file => // check if the parent file is any of the specified values
            val parent = file.getParentFile.getName
            args.map(_ == parent).reduce(_ || _)
        } sortWith { // sort by the numeric id
          _.getName.split(".").head.toInt < _.getName.split(".").head.toInt
        } map {
          file => // map files to commands to import
            val c = file.getParentFile.getName
            val cid = file.getName.split(".").head
            s"wem:put /sites/${site}/types/${c}/assets/${cid} <${file.getAbsolutePath}"
        }
        cmds.foreach(println)
        state
      } else state
  }

  val exportCmd = Command.args("asExport", "<asset-type>:<asset-id>") {
    (state, args) =>
      val extracted: Extracted = Project.extract(state)
      val base = (baseDirectory in extracted.currentRef get extracted.structure.data).get
      val site = (sitesFocus in extracted.currentRef get extracted.structure.data).get
      val url = (sitesUrl in extracted.currentRef get extracted.structure.data).get
      if (helloSites(url).nonEmpty) {
        //generate the sequence of connamds
        val content = base / "src" / "main" / "content"
        val cmds = args.map(_.split(":")).
          filter {
            a => // filter out the wrong assetid
              a.size == 2 && Try(a(1).toInt).isSuccess
          } map {
          a => // map files to commands to export
            val dir = content / a(0)
            dir.mkdirs
            val file = dir / s"${a(1)}.json"
            s"wem:get /sites/${site}/types/${a(0)}/assets/${a(1)} >${file}"
        }
        cmds.foreach(println)
        state
      } else state

  }

  val listCmd = Command.args("asList", "<asset-type>") {
    (state, args) =>
      val cmd = if (args.length == 0) {
        "csdt listcs @ALL_ASSETS"
      } else {
        "csdt listcs " + args.mkString(" ")
      }
      state.copy(remainingCommands =
        cmd +: state.remainingCommands)
  }

  val wemImportSettings = Seq(
    commands ++= Seq(listCmd, exportCmd, importCmd)
  )

}
