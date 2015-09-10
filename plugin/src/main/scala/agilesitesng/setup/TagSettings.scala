package agilesitesng.setup

import java.io.{File, FileReader}

import agilesites.config.AgileSitesConfigKeys
import org.xml.sax.InputSource
import sbt._
import sbt.Keys._

import scala.xml.XML

/**
 * Created by msciab on 04/08/15.
 */
trait TagSettings {
  this: AutoPlugin =>

  import AgileSitesConfigKeys._
  import NgSetupKeys._

  val javaKeywords = Set(
    "def", "abstract", "continue", "for", "new", "switch",
    "assert", "default", "goto", "package", "synchronized",
    "boolean", "do", "if", "private", "this",
    "break", "double", "implements", "protected", "throw",
    "byte", "else", "import", "public", "throws",
    "case", "enum", "instanceof", "return", "transient",
    "catch", "extends", "int", "short", "try",
    "char", "final", "interface", "static", "void",
    "class", "finally", "long", "strictfp", "volatile",
    "const", "float", "native", "super", "while", "string", "system")

  def tld2class(s: String) = {
    val f = (new File(s)).getName
    val f1 = f.take(f.size - 4)
    "%s%sTag".format(f1.charAt(0).toUpper, f1.substring(1))
  }

  def preHead(s: String) = {
    val cl = tld2class(s)
    """package agilesites.api;

import static agilesites.api.Api.*;
import COM.FutureTense.Interfaces.*;

public class %s  {
  private static Log log = Log.getLog(%s.class);
  static String ftValList2String(String name, FTValList vl)  {
    StringBuilder sb = new StringBuilder();
    sb.append(name);
    sb.append(":");
    java.util.Enumeration en = vl.keys();
    while (en.hasMoreElements()) {
      String k = en.nextElement().toString();
      Object v = vl.getValString(k);
      sb.append(" ").append(k).append("=").append(v!=null?v.toString():"null");
    }
    return sb.toString();
  }

    """.format(cl, cl)
  }

  def deKeyword(name: String) = if (javaKeywords.contains(name)) name + "_" else name

  def body(lib: String, name: String, parArgs: List[String]): String = {

    val uname = deKeyword(name)
    val cname = uname(0).toUpper + uname.substring(1)
    val lname = uname.toLowerCase;
    val tname = lib.toUpperCase + "." + uname.toUpperCase

    val setParams = parArgs map { x =>
      """ public %s %s(String val) { args.setValString("%s", val); return this; }
      """.format(cname, deKeyword(x), x.toUpperCase)
    } mkString "\n";

"""
  public static class %s {
  private FTValList args = new FTValList();
  private String output;
  public %s set(String name, String value) { args.setValString(name,value); return this; }
%s
  public %s() { }""".format(cname, cname, setParams, cname) + """
  public int run(ICS ics) {
      ics.runTag("%s", args);
      log.trace(ftValList2String("%s", args));
      return ics.GetErrno();
  }
  public String eval(ICS ics, String output) {
	  String tmp = tmp();
	  args.setValString(output.toUpperCase(), tmp);
	  run(ics);
	  String res = ics.GetVar(tmp);
	  ics.RemoveVar(tmp);
	  return res;
  }
  public %s set(Arg ... _args) {
	  for(Arg arg: _args) {
		  args.setValString(arg.name, arg.value);
	  }
	  return this;
  }
}
""".format(tname, cname, cname, cname) + """
public static %s %s() {
  return new %s();
}
""".format(cname, lname, cname)

  }

  val postHead = """
}
                 """

  def generate(filename: String) = {

    val saxParserFactory = javax.xml.parsers.SAXParserFactory.newInstance()
    saxParserFactory.setNamespaceAware(false)
    saxParserFactory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false)
    val saxParser = saxParserFactory.newSAXParser()

    // load file
    val xml = XML.loadXML(new InputSource(new FileReader(filename)), saxParser)

    // lib name
    val libname = new File(filename).getName.takeWhile(_ != '.')

    // enumerate tables
    val res = for (tag <- xml \\ "tag") yield {

      val tagname = (tag \ "name").text

      val attrs = tag \\ "attribute"
      val required = attrs.filter { a => (a \ "required").text == "true" }.distinct
      val optional = attrs.filter { a => (a \ "required").text == "false" }.distinct

      val reqList = required.map { x => (x \\ "name").text }.toList
      val optList = optional.map { x => (x \\ "name").text }.toList

      val parList = reqList ::: optList

      //println(s"${libname} ${tagname} ${parList}")

      body(libname, tagname, parList)

    }

    // result
    preHead(filename) +
      res.mkString("\n") +
      postHead
  }

  lazy val ngTagWrapperGenTask = ngTagWrapperGen := {

    val base = baseDirectory.value
    val dir = file(sitesWebapp.value)
    val ver = sitesVersion.value
    val dstDir = base / "src" / "main" / s"java-${sitesVersion.value}" / "agilesites" / "api"
    val tldDir = dir / "WEB-INF" / "futuretense_cs"

    if (!dir.exists || ver.isEmpty)
      println("cannot find sites tld!")
    else {
      if (!tldDir.isDirectory)
        println("no tld founds in " + tldDir)
      else {
        for {
          tld <- tldDir.listFiles
          if tld.getName.endsWith(".tld")
        } yield {
          val src = tld.getAbsolutePath
          val clsj = tld2class(src)
          val dstj = file(dstDir / clsj + ".java")
          val bodyj = generate(src)
          IO.write(dstj, bodyj)
          println("+++ " + dstj)
          dstj
        }
      }
    }
  }

  def tagSettings = Seq(ngTagWrapperGenTask)

}
