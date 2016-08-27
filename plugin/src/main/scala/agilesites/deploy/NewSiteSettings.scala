package agilesites.deploy

import java.io.{FileWriter, FileReader}
import java.util.Properties

import agilesites.Utils
import sbt.Keys._
import sbt._

trait NewSiteSettings extends Utils {
  this: AutoPlugin =>

  import agilesites.AgileSitesConstants.is11g
  import agilesites.config.AgileSitesConfigKeys._
  import agilesites.deploy.AgileSitesDeployKeys._

  def usage = println(
    """
      |usage: <sitename> <siteprefix>
    """.stripMargin)

  def validate(sitename: String, siteprefix: String) = {
    // todo use regexp to validate
    true
  }

  def prpInit(site: String) = {
    val prp = new Properties()
    val file = new File("agilesites.properties")
    if (file.exists())
      prp.load(new FileReader(file))
    prp.setProperty("sites.focus", site)
    prp.store(new FileWriter(file), "# by AgileSites 3.11 plugin")
  }

  def vWriteFile(file: File, body: String): Unit = {
    println(s"+++ ${file.getAbsolutePath}")
    writeFile(file, body, null)
  }

  def mkSite(base: File, static: File, siteName: String, sitePrefix: String) {
    val sitePackage = siteName.toLowerCase
    vWriteFile(base / s"${siteName}.java",
      s"""package ${sitePackage};
          |
          |import agilesites.annotations.AttributeEditor;
          |import agilesites.annotations.Site;
          |import agilesites.annotations.FlexFamily;
          |import agilesites.api.AgileSite;
          |
          |@FlexFamily(
          |       flexAttribute = "${sitePrefix}Attribute",
          |       flexParentDefinition = "${sitePrefix}ParentDef",
          |       flexContentDefinition = "${sitePrefix}ContentDef",
          |       flexFilter = "${sitePrefix}Filter",
          |       flexContent = "${sitePrefix}Content",
          |       flexParent = "${sitePrefix}Parent")
          |@Site(enabledTypes = {${if (!is11g) "\"WCS_Controller\"," else ""}
          |       "${sitePrefix}Attribute",
          |       "${sitePrefix}ParentDef",
          |       "${sitePrefix}ContentDef",
          |       "${sitePrefix}Content:F",
          |       "${sitePrefix}Parent:F",
          |       "SitePlan",
          |       "Template",
          |       "CSElement",
          |       "SiteEntry",
          |       "PageAttribute",
          |       "PageDefinition",
          |       "Page:F"
          |        })
          |public class ${siteName} extends AgileSite {
          |   @AttributeEditor
          |   private String ${sitePrefix}RichTextEditor = "<CKEDITOR/>";
          |
          |}
        """.stripMargin)
    vWriteFile(base / s"Config.java",
      s"""package ${sitePackage};
          |
          |public class Config extends wcs.java.Config {
          |	public static final String site = "${siteName}";
          |	@Override
          |	public String getSite() {
          |		return site;
          |	}
          |
          |	@Override
          |	public String getAttributeType(String type) {
          |		if (type == null)
          |			return null;
          |		if (type.equals("Page"))
          |			return "PageAttribute";
          |     		if (type.startsWith("${sitePrefix}"))
          |			return "${sitePrefix}Attribute";
          |		return null;
          |	}
          |}
        """.stripMargin)

    vWriteFile(base / s"Router.java",
      s"""package ${sitePackage};
          |
          |import wcs.api.*;
          |public class Router extends wcs.java.Router {
          |
          |	@Override
          |	public Call route(Env env, URL url) {
          |		return defaultRoute("Starter", env, url);
          |	}
          |
          |	@Override
          |	public String link(Env e, Id id, Arg... args) {
          |		return defaultLink(e, id, args);
          |	}
          |}
          |
        """.stripMargin)

    vWriteFile(base / "element" / s"${siteName}.java",
      s"""package ${sitePackage}.element;
          |
          |import static wcs.Api.*;
          |import wcs.api.Env;
          |import wcs.api.Asset;
          |import wcs.java.Element;
          |import wcs.java.Picker;
          |import agilesites.annotations.CSElement;
          |import agilesites.annotations.SiteEntry;
          |
          |@SiteEntry(wrapper = true)
          |@CSElement
          |public class ${siteName} extends Element {
          |    @Override
          |    public String apply(Env e)
          |    {
          |        Picker html = Picker.load("/${sitePackage}/template.html");
          |        // handle errors
          |        if (e.isVar("error"))
          |            return html.replace("#content",
          |                    e.call("${sitePrefix}Error", arg("error", e.getString("error"))))
          |                    .outerHtml();
          |        Asset a = e.getAsset();
          |        if (a == null)
          |            return html.replace("#content",
          |                    e.call("${sitePrefix}Error", arg("error", "Asset not found")))
          |                    .outerHtml();
          |        // render the asset using his default template
          |        html.replace("#content", a.call(a.getTemplate()));
          |        return html.outerHtml();
          |    }
          |}
          |""".stripMargin);

    vWriteFile(base / "element" / s"${sitePrefix}Error.java",
      s"""package ${sitePackage}.element;
          |
          |import agilesites.annotations.CSElement;
          |import agilesites.annotations.SiteEntry;
          |import wcs.api.*;
          |import wcs.java.Element;
          |import wcs.java.Picker;
          |import static wcs.Api.arg;
          |import static wcs.Api.model;
          |
        |@CSElement
          |public class ${sitePrefix}Error extends Element {
          |    @Override
          |    public String apply(Env e) {
          |        return Picker.load("/${sitePackage}/template.html", "#content")
          |                .html(model(arg("Title", "Error"),
          |                        arg("Text", e.getString("error"))));
          |    }
          |}
          |""".stripMargin);

    vWriteFile(static / "template.html",
      s"""<!DOCTYPE html>
          |<html>
          |<head>
          |<meta charset="utf-8">
          |<title>{{name}}</title>
          |<meta name="description" content="{{description}}">
          |</head>
          |<body>
          | <div id="content">
          |  <div>
          |   <h1>{{${sitePrefix}Title}}</h1>
          |  </div>
          |  <div>
          |   <p>{{${sitePrefix}Text}}</p>
          |  </div>
          | </div>
          |</body>
          |</html>""".stripMargin)

    vWriteFile(base / "model" / s"Page.java",
      s"""package ${sitePackage}.model;
          |
          |import agilesites.annotations.Type;
          |import agilesitesng.api.ASAsset;
          |
          |@Type
          |public class Page<S> extends ASAsset {
          |    S definition;
          |    public Page() { }
          |    public Page(S definition) { this.definition = definition; }
          |    public S getDefinition()  { return definition; }
          |    public S get() { return definition; }
          |}""".stripMargin);
    vWriteFile(base / "model" / s"${sitePrefix}Content.java",
      s"""package ${sitePackage}.model;
          |
          |import agilesites.annotations.Type;
          |import agilesitesng.api.ASAsset;
          |
          |@Type
          |public class ${sitePrefix}Content<S> extends ASAsset {
          |    S definition;
          |    public ${sitePrefix}Content() { }
          |    public ${sitePrefix}Content(S definition) { this.definition = definition; }
          |    public S getDefinition()  { return definition; }
          |    public S get() { return definition; }
          |}""".stripMargin);
    vWriteFile(base / "model" / s"${sitePrefix}Parent.java",
      s"""package ${sitePackage}.model;
          |
          |import agilesites.annotations.Type;
          |import agilesitesng.api.ASAsset;
          |
          |@Type
          |public class ${sitePrefix}Parent<S> extends ASAsset {
          |    S definition;
          |    public ${sitePrefix}Parent() { }
          |    public ${sitePrefix}Parent(S definition) { this.definition = definition; }
          |    public S getDefinition()  { return definition; }
          |    public S get() { return definition; }
          |}""".stripMargin);
    vWriteFile(base / "model" / "page" / s"${sitePrefix}Home.java",
      s"""package ${sitePackage}.model.page;
          |
        |import agilesites.annotations.*;
          |import ${sitePackage}.model.Page;
          |
        |@FindStartMenu("Find HomePage")
          |@NewStartMenu("New HomePage")
          |@ContentDefinition(flexAttribute = "PageAttribute",
          |        flexContent = "PageDefinition")
          |public class ${sitePrefix}Home extends Page {
          |
        |    @Attribute
          |    @Required
          |    private String ${sitePrefix}Title;
          |
        |    @Attribute(editor = "${sitePrefix}RichTextEditor")
          |    private String ${sitePrefix}Text;
          |
        |}
          |""".stripMargin);
  }

  val asNewSiteCmd = Command.args("asNewSite", "<site-name> <site-prefix>") {
    (state, args) =>
      if (args.length != 2 || !validate(args(0), args(1))) {
        usage
        state
      } else {
        val extracted: Extracted = Project.extract(state)
        val baseDir = (baseDirectory in extracted.currentRef get extracted.structure.data).get
        val base = baseDir / "src" / "main" / "java" / args(0).toLowerCase()
        val static = baseDir / "src" / "main" / "static" / args(0).toLowerCase
        /*if (base.exists()) {
          println(s"You have already a package for ${args(0)}")
        } else {*/
        prpInit(args(0))
        mkSite(base, static, args(0), args(1))
        //}
        state.copy(remainingCommands = "reload" +: state.remainingCommands)
      }
  }

  val newSiteSettings = Seq(commands += asNewSiteCmd)

}