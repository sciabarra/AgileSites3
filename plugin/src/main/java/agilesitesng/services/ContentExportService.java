package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import COM.FutureTense.Interfaces.IList;
import agilesites.api.Api;
import agilesites.api.AssetTag;
import agilesites.api.Range;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * Created by jelerak on 10/03/16.
 */
public class ContentExportService implements Service {

    public String export(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        if (ics.GetVar("cid") != null) {
            return exportAsset(req,ics,res);
        }
        else {
            return exportType(req,ics,res);
        }
    }

    public String exportType(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {

        String site = ics.GetVar("site");
        String list = Api.tmp();
        String contentType = ics.GetVar("type");
        String path = ics.GetVar("exportPath");

        System.out.println("contentType: " + contentType + " exportPath: " + path);

        AssetTag.list().type(contentType).excludevoided("true").list(list).run(ics); //.pubid(site)
        IList ls = ics.GetList(list);
        List<Long> ids = new ArrayList<>();
        if (ls != null) {
            Range range = new Range(ls.numRows());
            for (Integer index : range) {
                ls.moveTo(index);
                String cid = ls.getValue("id");
                ids.add(Long.parseLong(cid));
                //String jsonExport = exportAsset(ics, contentType, cid, path, site);
                //System.out.println(jsonExport);
            }
        }
        String json = null;
        try {
            ObjectMapper mapper = new ObjectMapper();
            json = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(ids);
        } catch (Exception e1) {
            e1.printStackTrace();
        }
        return json;

    }

    public String exportAsset(HttpServletRequest req, ICS ics, HttpServletResponse res) {
        String site = ics.GetVar("site");
        String cid = ics.GetVar("cid");
        String c = ics.GetVar("type");
        String path = ics.GetVar("exportPath");

        System.out.println("contentType: " + c + " cid: " + cid + " exportPath: " + path);

        res.setContentType("application/json");
        res.addHeader("res-content", "json");
        return exportAsset(ics, c, cid, path, site);
    }

    public String exportAsset(ICS ics, String c, String cid, String exportPath, String site) {
        String name = Api.tmp();
        String prefix = Api.tmp();
        // scatter asset
        AssetTag.load().name(name).type(c).objectid(cid).site(site).run(ics);
        AssetTag.scatter().name(name).prefix(prefix).fieldlist("*").run(ics);

        // order vars
        List<String> vars = new LinkedList<String>();
        Enumeration e = ics.GetVars();
        while (e.hasMoreElements()) vars.add(e.nextElement().toString());
        Collections.sort(vars);

        Map<String, String> assetMap = new HashMap<String, String>();
        assetMap.put("assetType", c);
        StringBuilder sb = new StringBuilder();
        for (String v : vars) {
            if (v.startsWith(prefix)) {
                String field = v.substring(prefix.length() + 1);
                if (field.startsWith("url") && !(v.endsWith("_folder") || v.endsWith("_file"))) {
                    if (ics.GetVar(v) == null || ics.GetVar(v).length() == 0)
                        AssetTag.get().name(name).field(field).output(v).run(ics);
                }
                sb.append(field).append("=").append(ics.GetVar(v)).append("\n");
                assetMap.put(field, ics.GetVar(v));
                //System.out.println(sb);
                //sb.append(field).append(" as bin is").append(ics.GetBin(v).length+"").append("\n");
            }
        }
        String json = null;
        try {
            ObjectMapper mapper = new ObjectMapper();
            String path = exportPath + "/" + c;
            String filename = cid+".json";
            JsonResponse response = new JsonResponse(path, filename);
            response.setValues(assetMap);
            json = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(response);
            //FileWriter fw = new FileWriter("/app/export/" + filename);
            //mapper.writeValue(fw,assetMap);
        } catch (Exception e1) {
            e1.printStackTrace();
        }
        return json;
    }

    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        if (ics.GetVar("op").equals("export"))
            return export(req, ics, res);
        if (ics.GetVar("op").equals("import"))
            return importAsset(req, ics, res);
        else return "???";
    }

    public String importContent(HttpServletRequest req, ICS ics, HttpServletResponse res) {

/*
        try {
            List<Path> filesInFolder = Files.walk(Paths.get("/app/export"))
                    .filter(Files::isRegularFile)
                    .filter(f -> f.endsWith(".json"))
                    .collect(Collectors.toList());

            for (Path path : filesInFolder) {
                String assetJson = Files.lines(path).collect(Collectors.joining());
                System.out.println(importAsset(ics, assetJson));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
*/
        return "";
    }


    public String importAsset(HttpServletRequest req, ICS ics, HttpServletResponse res) {
        String assetJson = ics.GetVar("assetJson");
        return importAsset(ics, assetJson);
    }

    public String importAsset(ICS ics, String assetJson) {
        ObjectMapper mapper = new ObjectMapper();
        Map<String, String> assetMap = null;
        try {
            assetMap = mapper.readValue(assetJson, new TypeReference<Map<String, String>>() {
                @Override
                public int compareTo(TypeReference<Map<String, String>> o) {
                    return super.compareTo(o);
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(assetMap);
        String assetId = assetMap.get("id");
        String assetType = assetMap.get("assetType");
        String site = ics.GetVar("site");
        String siteId = Utils.siteid(ics, site);
        String prefix = Api.tmp();

        for (String s : assetMap.keySet()) {
            ics.SetVar(prefix + ":" + s, assetMap.get(s));
        }

        String obj = Api.tmp();
        AssetTag.load().name(obj).type(assetType).objectid(assetId).editable("true").run(ics);
        AssetTag.get().name(obj).field("id").output("loadedId").run(ics);
        if (StringUtils.isEmpty(ics.GetVar("loadedId"))) {
            System.out.println("creating " + assetId);
            AssetTag.create().type(assetType).name(obj).run(ics);
            AssetTag.set().name(obj).field("id").value(assetId).run(ics);
            AssetTag.addsite().name(obj).pubid(siteId).run(ics);
            AssetTag.save().name(obj).flush("true").run(ics);
        }
        AssetTag.gather().name(obj).prefix(prefix).run(ics);
        //AssetTag.addsite().name(obj).pubid(siteid).run(ics);
        AssetTag.set().name(obj).field("id").value(assetId).run(ics);
        AssetTag.save().name(obj).run(ics);
        return "gather " + assetType + ":" + assetId + "@" + site + " is " + ics.GetErrno();

    }
}
