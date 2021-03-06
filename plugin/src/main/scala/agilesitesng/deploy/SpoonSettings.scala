package agilesitesng.deploy

import java.io.File

import agilesites.{Utils, AgileSitesConstants}
import agilesites.config.AgileSitesConfigKeys._
import agilesites.deploy.AgileSitesDeployKeys._
import sbt.Keys._
import sbt._

/**
  * Created by msciab on 06/08/15.
  */
trait SpoonSettings extends Utils {
  this: AutoPlugin =>

  import NgDeployKeys._

  val ngUidTask = ngUid := {
    val normName = normalizeSiteName(sitesFocus.value)
    val prpFile = baseDirectory.value / "src" / "main" / "resources" / normName / "uid.properties"
    val prp = new java.util.Properties
    prp.load(new java.io.FileReader(prpFile))
    import scala.collection.JavaConverters._
    prp.asScala.toMap
  }

  val spoonTask = spoon := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val normName = normalizeSiteName(sitesFocus.value)
    val uid = baseDirectory.value / "src" / "main" / "resources" / normName / "uid.properties"
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
    val spoonDebugger = if (ngSpoonDebugger.value) Seq("-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8005") else Seq()
    val templates = baseDirectory.value / "target" / "templates"
    val assets = baseDirectory.value / "src" / "main" / "assets"

    val jvmOpts = Seq(
      "-cp", sourceAndSpoonClasspath.mkString(File.pathSeparator),
      s"-Dspoon.spool=${spool.getAbsolutePath}",
      s"-Duid.properties=${uid.getAbsolutePath}",
      s"-Dspoon.outdir=${target.getAbsolutePath}",
      s"-Dspoon.templates=${templates.getAbsolutePath}",
      s"-Dspoon.assets=${assets.getAbsolutePath}",
      s"-Dspoon.site=${sitesFocus.value}",
      s"-Dspoon.skip.controller=${ngSpoonSkipControllers.value}")

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
      , "TemplateClassAnnotation"
      , "CSElementAnnotation"
      , "CSElementClassAnnotation"
      , "ControllerAnnotation"
      , "GroovyAnnotation"
    ).map(x => s"agilesitesng.deploy.spoon.${x}Processor")
    , ivyConfigurations += config("spoon")
    , libraryDependencies ++= AgileSitesConstants.spoonDependencies
    , spoonTask
    , ngUidTask
    , ngSpoonDebug := false
    , ngSpoonDebugger := false
    , ngSpoonSkipControllers := AgileSitesConstants.skipControllers
    , ngSpoon := {
      (spoon).toTask("").value
    }
  )
}
