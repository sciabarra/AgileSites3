package agilesitesng.deploy

import java.io.File

import agilesites.AgileSitesConstants
import agilesites.config.AgileSitesConfigKeys._
import agilesites.deploy.AgileSitesDeployKeys._
import sbt.Keys._
import sbt._

/**
  * Created by msciab on 06/08/15.
  */
trait SpoonSettings {
  this: AutoPlugin =>

  import NgDeployKeys._

  val ngUidTask = ngUid := {
    val prpFile = baseDirectory.value / "src" / "main" / "resources" / sitesFocus.value / "uid.properties"
    val prp = new java.util.Properties
    prp.load(new java.io.FileReader(prpFile))
    import scala.collection.JavaConverters._
    prp.asScala.toMap
  }

  val spoonTask = spoon := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val uid = baseDirectory.value / "src" / "main" / "resources" / name.value / "uid.properties"
    val source = baseDirectory.value / "src" / "main" / "java"
    val target = baseDirectory.value / "target" / "groovy"
    val spool = baseDirectory.value / "target" / "spoon-spool.json"
    val log = streams.value.log

    target.mkdirs
    spool.getParentFile.mkdirs

    val sourceClasspath = (fullClasspath in Runtime).value.files.filter(_.exists).map(_.getAbsolutePath)
    val spoonClasspath = ngSpoonClasspath.value.filter(_.exists).map(_.getAbsoluteFile)
    val sourceAndSpoonClasspath = spoonClasspath ++ sourceClasspath

    val processors = ngSpoonProcessors.value.mkString(File.pathSeparator)
    val spoonDebug = if (ngSpoonDebug.value) Seq("-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8005") else Seq()
    val templates = baseDirectory.value / "target" / "templates"
    val assets = baseDirectory.value / "src" / "main" / "assets"

    val jvmOpts = Seq(
      "-cp", sourceAndSpoonClasspath.mkString(File.pathSeparator),
      s"-Dspoon.spool=${spool.getAbsolutePath}",
      s"-Duid.properties=${uid.getAbsolutePath}",
      s"-Dspoon.outdir=${target.getAbsolutePath}",
      s"-Dspoon.templates=${templates.getAbsolutePath}",
      s"-Dspoon.assets=${assets.getAbsolutePath}",
      s"-Dspoon.site=${sitesFocus.value}"
    ) ++ spoonDebug

    val runOpts = Seq("agilesitesng.deploy.spoon.SpoonMain",
      "--source-classpath", sourceClasspath.mkString(File.pathSeparator),
      "--processors", processors,
      "-t", templates.getAbsolutePath,
      "-i", source.getAbsolutePath,
      "-o", target.getAbsolutePath
    ) ++ args

    if (ngSpoonDebug.value) {
      val file = baseDirectory.value / "spoon.sh"
      val fw = new java.io.FileWriter(file)
      for (src <- sourceClasspath) {
        log.debug(s"src-cp: ${src}")
        fw.write(s"#src: ${src}\n")
      }
      for (cp <- spoonClasspath) {
        log.debug(s"spoon-cp: ${cp}")
        fw.write(s"#spn: ${cp}\n")
      }
      val s = s"""java ${jvmOpts.mkString(" ")} ${runOpts.mkString(" ")}"""
      fw.write(s.replaceAll(":", ":\\\n"))
      fw.close
      println(s" +++${file}")
    }

    val forkOpt = ForkOptions(
      bootJars = spoonClasspath,
      runJVMOptions = jvmOpts,
      workingDirectory = Some(baseDirectory.value))

    Fork.java(forkOpt, runOpts)

    spool
  }

/*
  val processAnnotations = Def.task {

    val comp: Compiler.Compilers = (compilers in Compile).value
    val mcp: Seq[File] = (managedClasspath in Compile).value.files
    val ucp: Seq[File] = (unmanagedClasspath in Compile).value.files
    val src: File = (sourceDirectory in Compile).value
    val out: File = (sourceDirectory in Compile).value
    val log = streams.value.log
    val in = (src ** "*.java").get

    val opt = Seq(
      "-proc:only",
      "-processor",
      "agilesitesng.processors.HelperAnnotationProcessor",
      "-s",
      out.getAbsolutePath)

    //log.info(in.mkString("in:", " ", ""))
    //log.info(mcp.mkString("mcp: ", " ", ""))
    //log.info(opt.mkString("opt: ", " ", ""))

    try {
      out.mkdirs()
      comp.javac(in, mcp++ucp, out, opt)(log)
    } catch {
      case ex: Throwable =>
        log.error(ex.getMessage)
    }
    Seq.empty[File]
  }
*/


  val spoonSettings = Seq(
    ngSpoonClasspath <<= (Keys.update) map {
      (report) =>
        report.select(configurationFilter("spoon"))
    }, ngSpoonProcessors := Seq(
      "FlexFamilyAnnotation"
      , "SiteAnnotation"
      , "TypeAnnotation"
      , "AttributeEditorAnnotation"
      , "AttributeAnnotation"
      , "ParentDefinitionAnnotation"
      , "ContentDefinitionAnnotation"
      , "RequiredAnnotation"
      , "AttributeAnnotationClean"
      , "ParentsAnnotation"
      , "AssetSubtypesAnnotation"
      , "NewStartMenuAnnotation"
      , "FindStartMenuAnnotation"
      , "MultipleStartMenuAnnotation"
      , "SiteEntryAnnotation"
      , "TemplateAnnotation"
      , "CSElementAnnotation"
      , "ControllerAnnotation"
      , "GroovyAnnotation"
    ).map(x => s"agilesitesng.deploy.spoon.${x}Processor")
    , ivyConfigurations += config("spoon")
    , libraryDependencies ++= AgileSitesConstants.spoonDependencies
    , spoonTask
    , ngUidTask
    , ngSpoonDebug := false
    , ngSpoon := {
      (spoon).toTask("").value
    }
    //,sourceGenerators in Compile ++= Seq(processAnnotations.taskValue)
  )
}
