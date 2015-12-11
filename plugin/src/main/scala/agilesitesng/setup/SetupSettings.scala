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
          "AdminSite", file, streams.value.log)
      else
        println(s"${file} does not exist")
    }
  }

  def mkSite(base: File, siteName: String, log: Logger) {

    val sitePackage = siteName.toLowerCase

    val folder = base / "src" / "main" / "java" / sitePackage
    folder.mkdirs
    writeFile(folder / s"${siteName}.java",
      s"""
        |package ${sitePackage};
        |
        |import agilesites.annotations.AttributeEditor;
        |import agilesites.annotations.Site;
        |import agilesites.annotations.FlexFamily;
        |import agilesites.api.AgileSite;
        |
        |@FlexFamily(
        |       flexAttribute = "${siteName}Attribute",
        |       flexParentDefinition = "${siteName}ParentDefinition",
        |       flexContentDefinition = "${siteName}ContentDefinition",
        |       flexFilter = "${siteName}Filter",
        |       flexContent = "${siteName}Content",
        |       flexParent = "${siteName}Parent")
        |@Site(enabledTypes = {"${siteName}Attribute",
        |       "${siteName}ParentDefinition",
        |       "${siteName}ContentDefinition",
        |       "${siteName}Content:F",
        |       "${siteName}Parent:F",
        |       "Template",
        |       "CSElement",
        |       "SiteEntry",
        |       "Controller",
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

  def checkArg(n: Integer, prop: String, prompt: String, validate: String => Boolean)
              (implicit args: Seq[String], prp: Properties, scanner: Scanner): String = {
    val value = if (args.length > n)
      args(n)
    else if (prp.getProperty(prop) == null) {
      println(prompt)
      scanner.next()
    } else
      prp.getProperty("sites.url")
    if (validate(value))
      value
    else {
      println("ERROR! Try again.")
      checkArg(n, prop, prompt, validate)
    }
  }

  def isUrl(x: String) = Try(new java.net.URL(x)).isSuccess
  def isAlphaNumeric(x: String) =  x.forall(_.isLetterOrDigit)

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

      val url = new java.net.URL(checkArg(0, "sites.url", "Sites URL (a valid URL)", isUrl))
      val user = checkArg(1, "sites.user", "Sites Admin Username (not empty)", _.trim.size > 0)
      val pass = checkArg(2, "sites.pass", "Sites Admin Password (not empty)", _.trim.size > 0)
      val focus = checkArg(3, "sites.focus", "Your new Site name (short, alphanumeric, no spaces)", isAlphaNumeric)

      prp.setProperty("sites.url", url.toString)
      prp.setProperty("sites.port", url.getPort.toString)
      prp.setProperty("sites.user", user)
      prp.setProperty("sites.pass", pass)
      prp.setProperty("sites.focus", focus)

      val err = doSetup(url, user, pass, streams.value.log)
      if (err.isEmpty) {
        val fw = new java.io.FileWriter("agilesites.properties")
        prp.store(fw, "Created by AgileSites")
        fw.close
        log.info("Created agilesites.properties")
        println(s"Creating ${focus} in ${base} ")
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
    setupOnlyDefault := (if ((baseDirectory.value / "plugin").exists) "../" else "") +
      "plugin/src/main/resources/aaagile/ElementCatalog/AAAgileServices.txt"
  )
}

/*
  val url = new java.net.URL(if (args.length > 0)
    args(0)
  else if (prp.getProperty("sites.url") == null) {
    println("Sites URL: ")
    scanner.next()
  } else prp.getProperty("sites.url"))

  val user = if (args.length > 1)
    args(1)
  else if (prp.getProperty("sites.user") == null) {
    println("Sites User:")
    scanner.next()
  } else prp.getProperty("sites.user")

  val pass = if (args.length > 2)
    args(2)
  else if (prp.getProperty("sites.pass") == null) {
    println("Sites Password:")
    scanner.next()
  } else prp.getProperty("sites.pass")

  val focus = if (args.length > 3)
    args(3)
  else if (prp.getProperty("sites.focus") == null) {
    println("Your new Site name (short, no spaces):")
    scanner.next()
  } else prp.getProperty("sites.focus")*/
