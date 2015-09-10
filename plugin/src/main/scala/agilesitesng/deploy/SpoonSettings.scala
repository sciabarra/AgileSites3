package agilesitesng.deploy

import java.io.File

import agilesites.AgileSitesConstants
import sbt.Keys._
import sbt._

/**
 * Created by msciab on 06/08/15.
 */
trait SpoonSettings {
  this: AutoPlugin =>

  import NgDeployKeys._

  val spoonTask = spoon in ng := {
    val args: Seq[String] = Def.spaceDelimited("<arg>").parsed
    val uid = baseDirectory.value / "src" / "main" / "resources" / name.value / "uid.properties"
    val source = baseDirectory.value / "src" / "main" / "java"
    val target = baseDirectory.value / "target" / "groovy"
    val spool = baseDirectory.value / "target" / "spoon-spool.json"
    val extraJars = ngSpoonProcessorJars.value
    val log = streams.value.log

    target.mkdirs
    spool.getParentFile.mkdirs

    val sourceClasspath = (extraJars ++ (managedClasspath in Compile).value.files.map(_.getAbsolutePath)).mkString(File.pathSeparator)
    val spoonClasspath = extraJars ++ ngSpoonClasspath.value.map(_.getAbsoluteFile)

    val processors = ngSpoonProcessors.value.mkString(File.pathSeparator)
    val spoonDebug = if (ngSpoonDebug.value) Seq("-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8005") else Seq()

    val jvmOpts = Seq(
      //"-cp", spoonClasspath.mkString(File.pathSeparator),
      s"-Dspoon.spool=${spool.getAbsolutePath}",
      s"-Duid.properties=${uid.getAbsolutePath}",
      s"-Dspoon.outdir=${target.getAbsolutePath}"
    ) ++ spoonDebug

    val runOpts = Seq("agilesitesng.deploy.spoon.SpoonMain",
      "--source-classpath", sourceClasspath,
      "--processors", processors,
      "-i", source.getAbsolutePath,
      "-o", target.getAbsolutePath
    ) ++ args

    //log.debug(s"spoonClasspath=${spoonClasspath.replace(File.pathSeparator, "\n")}")
    //log.debug( (jvmOpts++runOpts).mkString("\n"))

    val file = baseDirectory.value / "spoon.sh"
    val fw = new java.io.FileWriter(file)
    val s = s"""java ${jvmOpts.mkString(" ")} ${runOpts.mkString(" ")}"""
    fw.write(s.replaceAll(":", ":\\\n"))
    fw.close
    println(s" +++${file}")

    val forkOpt = ForkOptions(
      bootJars = spoonClasspath,
      runJVMOptions = jvmOpts,
      workingDirectory = Some(baseDirectory.value))

    Fork.java(forkOpt, runOpts)

    spool
  }

  val spoonSettings = Seq(ngSpoonClasspath <<= (Keys.update, ngSpoonProcessorJars) map {
    (report, extraJars) =>
      extraJars ++ report.select(configurationFilter("spoon"))
  } , ngSpoonProcessorJars := Nil
    , ngSpoonProcessors := Seq(
      "FlexFamilyAnnotation"
      , "SiteAnnotation"
      , "ParentDefinitionAnnotation"
      , "ContentDefinitionAnnotation"
      , "AttributeEditorAnnotation"
      , "AttributeAnnotation"
      , "NewStartMenuAnnotation"
      , "FindStartMenuAnnotation"
      , "SiteEntryAnnotation"
      , "TemplateAnnotation"
      , "ControllerAnnotation"
      , "CSElementAnnotation")
      .map(x => s"agilesitesng.deploy.spoon.${x}Processor")
    , ivyConfigurations += config("spoon")
    , libraryDependencies ++= AgileSitesConstants.spoonDependencies
    , spoonTask
    , ngSpoonDebug := false
  )
}
