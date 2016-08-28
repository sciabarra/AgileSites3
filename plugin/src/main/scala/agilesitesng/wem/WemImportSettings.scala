package agilesitesng.wem

import agilesites.Utils
import agilesites.config.AgileSitesConfigKeys
import sbt._, Keys._
import scala.util.Try

/**
  * Created by msciab on 25/08/16.
  */
trait WemImportSettings extends Utils {
  this: AutoPlugin =>

  import AgileSitesConfigKeys._

  val importCmd = Command.args("asImport", "<asset-types>") {
    (state, args) =>
      val extracted: Extracted = Project.extract(state)
      val base = (baseDirectory in extracted.currentRef get extracted.structure.data).get
      val site = (sitesFocus in extracted.currentRef get extracted.structure.data).get
      val url = (sitesUrl in extracted.currentRef get extracted.structure.data).get
      val content = base / "src" / "main" / "content"
      if (helloSites(url, false).nonEmpty) {
        val files = (content ** "*.json").get
        println(files)
        val cmds = files.filter {
          file =>
            // check if the parent file is any of the specified folder
            // (empty => accept all)
            val parent = file.getParentFile.getName
            args.isEmpty || args.map(_ == parent).reduceLeft(_ || _)
        } sortWith {
          // sort by the numeric id
          _.getName.split("\\.").head.toLong < _.getName.split("\\.").head.toLong
        } map {
          file => // map files to commands to import
            val c = file.getParentFile.getName
            val cid = file.getName.split("\\.").head
            println(s"importing ${c}:${cid}")
            val cmd = s"wem:put /sites/${site}/types/${c}/assets/${cid} <${file.getAbsolutePath}"
            println(cmd)
            cmd
        }
        state.copy(remainingCommands = cmds ++ state.remainingCommands)
      } else {
        println("Sites is not accessible")
        state
      }
  }

  val exportCmd = Command.args("asExport", "<asset-type>:<asset-id>...") {
    (state, args) =>
      val extracted: Extracted = Project.extract(state)
      val base = (baseDirectory in extracted.currentRef get extracted.structure.data).get
      val site = (sitesFocus in extracted.currentRef get extracted.structure.data).get
      implicit val url = new java.net.URL((sitesUrl in extracted.currentRef get extracted.structure.data).get)
      implicit val userPass = (sitesUser in extracted.currentRef get extracted.structure.data).get ->
        (sitesPassword in extracted.currentRef get extracted.structure.data).get
      if (args.size == 0) {
        println("usage: <AssetType>:<AssetName>...")
        state
      } else if (helloSites(url.toString, false).nonEmpty) {
        //generate the sequence of connamds
        val content = base / "src" / "main" / "content"
        val cmds = args.
          map { s => // decode Page:Name in Page:id
            serviceCall("decode", s"value=$s@$site")
          } map {
          _.split(":")
        } filter {
          a => // filter out the wrong assetid
            val res = a.size == 2 && Try(a(1).toLong).isSuccess
            //println(s"filter ${a mkString " "}:${res}")
            res
        } map {
          a => // map files to commands to export
            println(s"exporting ${a(0)}:${a(1)}")
            val dir = content / a(0)
            dir.mkdirs
            val file = dir / s"${a(1)}.json"
            s"wem:get /sites/${site}/types/${a(0)}/assets/${a(1)} >${file}"
        }
        //cmds.foreach(println)
        state.copy(remainingCommands = cmds ++ state.remainingCommands)
      } else {
        println("Sites not running")
        state
      }

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

  val removeSiteCmd = Command.command("asRemoveSite") {
    state =>
      val extracted: Extracted = Project.extract(state)
      val site = (sitesFocus in extracted.currentRef get extracted.structure.data).get
      val user = (sitesUser in extracted.currentRef get extracted.structure.data).get
      val pass = (sitesPassword in extracted.currentRef get extracted.structure.data).get

      val cmd = s"service sitedelete ${site} username=${user} password=${pass}"
      state.copy(remainingCommands = cmd +: state.remainingCommands)
  }

  val wemImportSettings = Seq(
    commands ++= Seq(listCmd, exportCmd, importCmd, removeSiteCmd)
  )

}
