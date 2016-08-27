package agilesites.setup

import java.io.File

import agilesites.{AgileSitesConstants, Utils}
import sbt.Keys._
import sbt._

trait ToolsSettings extends Utils {
  this: AutoPlugin =>

  import agilesites.config.AgileSitesConfigKeys._
  import agilesites.setup.AgileSitesSetupKeys._

  // find the default workspace from sites
  def defaultWorkspace(sites: String) = normalizeSiteName(sites.split(",").head)

  lazy val cmovClasspathTask = cmovClasspath <<= (sitesHome, baseDirectory) map {
    (home, base) =>
      val h = file(home)
      Seq(base / "bin", h / "bin") ++
        (h * "*.jar").get ++
        (h / "Sun" ** "*.jar").get ++
        (h / "wem" ** "*.jar").get
  }

  val cmovTask = cmov := {
    val args = Def.spaceDelimited("<arg>").parsed
    val log = streams.value.log

    if (args.length == 0) {
      println(
        s"""usage: cmov <cmd> [@][<dir>...] [<options>....]])
            |<cmd> one of view, setup, import, import_all, export, export_all
            |[@]<dir> if start with @ uses all the contained dirs otherwise just the specified dir,
            |    defaults to @${sitesPopulate.value},
            |<options> can be:
            |    -b base URL  (defaults to ${sitesUrl.value}/CatalogManager)                                                                                                       |-u user name (defaults to ${sitesUser.value})
          """.stripMargin)
    } else {
      val cp = (Seq(file("bin").getAbsoluteFile) ++ cmovClasspath.value).mkString(java.io.File.pathSeparator)

      val coreJar = update.value.matching({ x: ModuleID =>
        x.name == AgileSitesConstants.agilesitesPlugin.name &&
          x.organization == AgileSitesConstants.agilesitesPlugin.organization
      }).headOption

      println(s"coreJar=${coreJar}")
      val populateJars = asPopulateClasspath.value.filter(!_.getName.startsWith("scala-library"))

      if (sitesHello.value.isEmpty)
        throw new Exception(s"Web Center Sites must be online as ${sitesUrl.value}.")

      val populateDir = file(sitesPopulate.value) / "setup"
      val cmd = if (coreJar.nonEmpty && args(0) == "setup") {
        if (coreJar.get.exists()) {
          log.info(s"extracting aaagile from ${coreJar.get.getName}")
          IO.unzip(coreJar.get, populateDir, GlobFilter("aaagile/*"))
        }
        for (jar <- populateJars) {
          log.info(s"extracting from ${jar.getName}")
          IO.unzip(jar, populateDir.getParentFile, GlobFilter("populate/*"))
        }
        IO.delete(populateDir / "META-INF")
        "import_all"
      } else
        args(0)

      val set = args.toSet
      val opts =
        Seq("-x", cmd) ++ args.drop(2) ++
          (if (set("-b")) Seq() else Seq("-b", sitesUrl.value + "/CatalogManager")) ++
          (if (set("-u")) Seq() else Seq("-u", sitesAdminUser.value)) ++
          (if (set("-p")) Seq() else Seq("-p", sitesAdminPassword.value))

      val baseDir = if (args.length > 1) args(1) else "@" + populateDir.getAbsolutePath
      println(s"baseDir=${baseDir}")

      // get dirs
      val dirs = if (baseDir.startsWith("@")) {
        // multiple dirs
        val dir = file(baseDir.substring(1))
        if (dir.exists())
          (dir * "*").filter(_.isDirectory).get
        else
          Seq()
      } else {
        // single dir
        val dir = file(baseDir)
        if (dir.isAbsolute) {
          // absolute
          if (dir.exists)
            Seq(dir)
          else {
            println("not found" + dir)
            Seq()
          }
        } else {
          // relative
          val dir = file(sitesPopulate.value + File.separator + baseDir)
          if (dir.exists)
            Seq(dir)
          else {
            println("not found" + dir)
            Seq()
          }
        }
      }

      if (cmd == "view")
        Fork.java(ForkOptions(
          runJVMOptions = Seq("-cp", cp),
          workingDirectory = Some(baseDirectory.value)),
          Seq("COM.FutureTense.Apps.CatalogMover"))
      else
        for (dir <- dirs) {
          println("*** " + dir)
          Fork.java(ForkOptions(
            runJVMOptions = Seq("-cp", cp),
            workingDirectory = Some(baseDirectory.value)),
            "COM.FutureTense.Apps.CatalogMover" +: (Seq("-d", dir.getAbsolutePath) ++ opts))
        }
    }
  }

  val csdtTask = csdt := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val home = sitesHome.value
    val version = sitesVersion.value
    val url = sitesUrl.value
    val user = sitesUser.value
    val password = sitesPassword.value
    val seljars = csdtClasspath.value
    val log = streams.value.log
    val envision = file(sitesEnvision.value)

    if (!envision.isDirectory)
      throw new Exception(s"not found envision directory ${envision.getAbsolutePath}")

    val sites = sitesFocus.value
    val defaultSite = sites.split(",").head

    val defaultWorkspace = envision / defaultSite
    if (!defaultWorkspace.exists())
      defaultWorkspace.mkdir

    val workspaces = envision.listFiles.filter(_.isDirectory).map(_.getName)
    val workspaceSearch = (s"#${defaultSite}#" +: args).reverse.filter(_.startsWith("#")).head.substring(1)

    val workspace = if (!workspaceSearch.endsWith("#"))
      workspaces.filter(_.indexOf(workspaceSearch) != -1)
    else workspaces.filter(_ == workspaceSearch.init)

    val fromSites = (("!" + defaultSite) +: args).reverse.filter(_.startsWith("!")).head.substring(1)
    val toSites = (("^" + fromSites) +: args).reverse.filter(_.startsWith("^")).head.substring(1)

    if (args.size > 0 && args(0) == "raw") {
      Run.run("com.fatwire.csdt.client.main.CSDT",
        seljars, args.drop(1), streams.value.log)(runner.value)
    } else if (args.size == 0) {
      println(
        """usage: csdt <cmd> <selector> ... [#<workspace>[#]] [!<from-sites>] [^<to-sites>]
          | <workspace> is a substring of available workspaces, use #workspace# for an exact match
          |   default workspace is: %s
          |   available workspaces are: %s
          | <from-sites> and <to-sites> is a comma separated list of sites defined,
          |   <from-sites> defaults to <workspace>,
          |   <to-sites> defaults to <from-sites>
          | <cmd> is one of 'listcs', 'listds', 'import', 'export', 'mkws'
          | <selector> check developer tool documentation for complete syntax
          |    you can use <AssetType>[:<id>] or a special form,
          |    the special form are
          |      @SITE @ASSET_TYPE @ALL_ASSETS @STARTMENU @TREETAB
          |  and also additional @ALL for all of them
          | """.stripMargin.format(defaultSite, workspaces.mkString("'", "', '", "'")))
    } else if (workspace.size == 0)
      println("workspace " + workspaceSearch + " not found - create it with mkws <workspace>")
    else if (workspace.size > 1)
      println("workspace " + workspaceSearch + " is ambigous")
    else {

      def processArgs(args: Seq[String]) = {
        if (args.size == 0 || args.size == 1) {
          println(
            """please specify what you want to export or use @ALL to export all
              | you can use <AssetType>[:<id>] or a special form,
              | the special form are
              |   @SITE @ASSET_TYPE @ALL_ASSETS @STARTMENU @TREETAB @ROLE
              |  and also additional @ALL meaning  all of them""".stripMargin)
          Seq()
        } else if (args.size == 2 && args(1) == "@ALL") {
          Seq("@SITE", "@ASSET_TYPE", "@ALL_ASSETS", "@STARTMENU", "@TREETAB", "@ROLE")
        } else {
          args.drop(1)
        }
      }

      val args1 = args.filter(!_.startsWith("#")).filter(!_.startsWith("!")).filter(!_.startsWith("^"))
      val firstArg = if (args1.size > 0) args1(0) else "listcs"
      val resources = firstArg match {
        case "listcs" => processArgs(args1)
        case "listds" => processArgs(args1)
        case "import" => processArgs(args1)
        case "export" => processArgs(args1)
        case "mkws" =>
          if (args1.size == 1) {
            println("please specify workspace name")
          } else {
            val ws = envision / args1(1)
            if (ws.exists)
              println("nothing to do - workspace " + args1(1) + " exists")
            else {
              ws.mkdirs
              if (ws.exists)
                println(" workspace " + args1(1) + " created")
              else
                println("cannot create workspace " + args1(1))
            }
          }
          Seq()
        case _ =>
          println("Unknown command")
          Seq()
      }

      for (res <- resources) {
        val cmd = Array(url + "/ContentServer",
          "username=" + user,
          "password=" + password,
          "cmd=" + firstArg,
          "resources=" + res,
          "fromSites=" + fromSites,
          "toSites=" + toSites,
          "datastore=" + workspace.head)

        log.debug(seljars.mkString("\n"))
        //s.log.debug(cmd.mkString(" "))
        Run.run("com.fatwire.csdt.client.main.CSDT", seljars, cmd, log)(runner.value)
      }
    }
  }

  val toolsSettings = Seq(cmovTask, csdtTask,
    cmovClasspathTask,
    csdtHome := file(sitesHome.value) / "csdt-client",
    csdtClasspath := (csdtHome.value ** "*.jar").get)
}