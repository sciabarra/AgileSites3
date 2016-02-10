package agilesitesng.setup

import sbt._
import Keys._
import agilesites.Utils
import java.util.{Scanner, Properties}

import scala.util.Try

/**
  * Created by msciab on 04/11/15.
  */
trait SetupSettings
  extends Utils
  with NgSetupSupport {
  this: AutoPlugin =>

  import NgSetupKeys._
  import agilesites.config.AgileSitesConfigKeys._

  lazy val setupOnlyTask = setupOnly := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val args1 = if (args.isEmpty) Seq(setupOnlyDefault.value) else args
    for (filename <- args1) {
      val file = new java.io.File(filename)
      if (file.exists)
        doSetupOnly(new java.net.URL(sitesUrl.value), sitesUser.value, sitesPassword.value,
          "AdminSite", file, streams.value.log, sitesTimeout.value)
      else
        println(s"${file} does not exist")
    }
  }

  def mkSite(base: File, siteName: String, log: Logger) {

    val sitePackage = siteName.toLowerCase
    val folder = base / "src" / "main" / "java" / sitePackage
    val fileJava = folder / s"${siteName}.java"
    if (!fileJava.exists) {
      folder.mkdirs
      writeFile(fileJava,
        s"""
          |package ${sitePackage};
          |
          |import agilesites.annotations.AttributeEditor;
          |import agilesites.annotations.Site;
          |import agilesites.annotations.FlexFamily;
          |import agilesites.api.AgileSite;
          |
          |@FlexFamily(
          |       flexAttribute = "${siteName}_A",
          |       flexParentDefinition = "${siteName}_PD",
          |       flexContentDefinition = "${siteName}_CD",
          |       flexFilter = "${siteName}_F",
          |       flexContent = "${siteName}_C",
          |       flexParent = "${siteName}_P")
          |@Site(enabledTypes = {"${siteName}_A",
          |       "${siteName}_PD",
          |       "${siteName}_CD",
          |       "${siteName}_C:F",
          |       "${siteName}_P:F",
          |       "WCS_Controller",
          |       "Template",
          |       "CSElement",
          |       "SiteEntry",
          |       "PageAttribute",
          |       "PageDefinition",
          |       "Page:F"})
          |public class ${siteName} extends AgileSite {
          |
          |   @AttributeEditor
          |   private String ${siteName}RichTextEditor = "<CKEDITOR/>";
          |
          |}
        """.stripMargin, log)
    }
  }

  def checkArg(n: Integer, prop: String, prompt: String, validate: String => Boolean)
              (implicit args: Seq[String], prp: Properties, scanner: Scanner): String = {

    var value = if (args.length > n)
      args(n)
    else if (prp.getProperty(prop) == null) {
      println(prompt)
      scanner.next()
    } else prp.getProperty(prop)

    while (!validate(value)) {
      println(prompt)
      value = scanner.next()
    }
    value
  }

  def isUrl(x: String) = Try(new java.net.URL(x)).isSuccess

  def isAlphaNumeric(x: String) = x.forall(_.isLetterOrDigit)

  lazy val setupTask = setup := {
    implicit val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    implicit val scanner = new Scanner(System.in);
    implicit val prp = new Properties
    val log = streams.value.log
    val base = baseDirectory.value

    try {
      val file = new java.io.File("agilesites.properties")
      if (file.exists())
        prp.load(new java.io.FileReader(file))

      println(
        """********** Configuring AgileSites **********
          |* Please answer to the following questions *
          |********************************************
          | """.stripMargin)

      val url = new java.net.URL(checkArg(0, "sites.url", "Type a Sites 12c valid URL and press enter.\n (Example: http://10.0.2.15:7003/sites) :", isUrl))
      val user = checkArg(1, "sites.user", "Type a Sites Admin Username\n (example: fwadmin) :", _.trim.size > 0)
      val pass = checkArg(2, "sites.password", "Type a Sites Admin Password\n (example: xceladmin) :", _.trim.size > 0)
      val focus = checkArg(3, "sites.focus", "Type your new Site name (short, alphanumeric, no spaces)\n (example: Site ) :", isAlphaNumeric)

      prp.setProperty("sites.url", url.toString)
      prp.setProperty("sites.port", url.getPort.toString)
      prp.setProperty("sites.user", user)
      prp.setProperty("sites.password", pass)
      prp.setProperty("sites.focus", focus)
      prp.setProperty("sites.timeout", "30")

      val err = doSetup(url, user, pass, streams.value.log, sitesTimeout.value)
      if (err.isEmpty) {
        val fw = new java.io.FileWriter("agilesites.properties")
        prp.store(fw, "Created by AgileSites")
        fw.close
        log.info("Created agilesites.properties")
        //println(s"Creating ${focus} in ${base} ")
        mkSite(base, focus, log)
        None
      } else err

    } catch {
      case ex: Throwable =>
        log.error(ex.getMessage)
        Some(ex.getMessage)
    }
  }

  val setupSettings = Seq(setupTask, setupOnlyTask,
    setupOnlyDefault := {
      //println("eccomi")
      val base = baseDirectory.value.getParentFile
      val service = "plugin/src/main/resources/aaagile/ElementCatalog/AAAgileServices.txt"
      (base / service).getAbsolutePath
    }
  )
}

