<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Flex/Audit/ShowDefinitionTree
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<%!
class TemplateNode {
    String assetdef;
    String id;
    String name;
    int level=0;
    java.util.List children =  new java.util.LinkedList();

    void doChildDefs(ICS ics ){
        String sql="SELECT td.id AS id, td.name AS name FROM "+ assetdef + " td ,  "+ assetdef+ "_TGroup tg WHERE td.id = tg.ownerid AND tg.PRODUCTGROUPTEMPLATEID = "+ id + " ORDER BY name";
        IList list = ics.SQL(assetdef, sql, assetdef+"-"+id ,-1,true,new StringBuffer());
        if (list != null & list.hasData()){
            int rows = list.numRows()+1;
            for (int i=1;i<rows;i++){
                list.moveTo(i);
                TemplateNode node = new TemplateNode();
                try {
                    //System.out.println(list.getValue("id"));
                    node.id= list.getValue("id");
                    node.name= list.getValue("name");
                    node.assetdef = assetdef;
                    node.level=level+1;
                    children.add(node);
                    node.doChildDefs(ics);
                } catch (Exception e){
                    e.printStackTrace();
                }
            }
        }
    }

    void printAttributes(ICS ics){
        try {
            String sql="SELECT assetattr FROM FlexGrpTmplTypes where assettype='"+ assetdef + "'";
            IList list = ics.SQL("FlexGrpTmplTypes", sql, null ,-1,true,new StringBuffer());

            list.moveTo(1);
            String attrtype = list.getValue("assetattr");
            sql="SELECT a.name AS name FROM " + attrtype + " a, "+ assetdef + "_TAttr ta where ta.ownerid = "+ id +" AND a.id = ta.attributeid order by name";
            list = ics.SQL(assetdef + "_TAttr", sql, null ,-1,true,new StringBuffer());
            if (list != null & list.hasData()){
                int rows = list.numRows()+1;
                for (int i=1;i<rows;i++){
                    list.moveTo(i);

                        ics.StreamEvalBytes("<tr><td>");
                        ics.StreamEvalBytes(list.getValue("name"));
                        ics.StreamEvalBytes("</td></tr>");
                }
            }
        } catch (Exception e){
            e.printStackTrace();
        }

    }
    void print(ICS ics){
        StringBuffer buffy = new StringBuffer("<table class=\"altClass\"><tr><td colspan=\"2\"><b>");
        buffy.append(level);
        //buffy.append("/");
        //buffy.append(id);
        buffy.append("/");
        buffy.append(name);
        buffy.append("/");
        buffy.append(assetdef);
        buffy.append("</b></td></tr>");
        ics.StreamEvalBytes(buffy.toString());
        ics.StreamEvalBytes("<tr><td valign=\"top\"><table cellspacing=\"1px\" bgcolor=\"#CCFF99\">");
        printAttributes(ics);
        ics.StreamEvalBytes("</table></td><td>");

        for (Iterator itor = children.iterator();itor.hasNext();){
            TemplateNode child = (TemplateNode)itor.next();
            child.print(ics);
        }
        ics.StreamEvalBytes("</td></tr></table>\r\n");
    }
}
%>
<cs:ftcs>
<h3>Flex Asset Definition Tree</h3>

<ics:sql sql='SELECT assettemplate FROM FlexGroupTypes ORDER BY assettemplate' table='FlexGroupTypes' listname="templatetypes"/>

<ics:listloop listname="templatetypes">
    <i><h4><ics:resolvevariables name="templatetypes.assettemplate"/></h4></i><br/>
    <ics:clearerrno/>
    <ics:sql sql='<%= ics.ResolveVariables("select td.name as name , td.id as id from templatetypes.assettemplate td where not exists (select 1 from templatetypes.assettemplate_TGroup tg where td.id = tg.ownerid) AND td.status != \'VO\' order by name") %>' table='<%=ics.ResolveVariables("templatetypes.assettemplate") %>' listname="defs"/>
    <ics:listloop listname="defs">
        <% {
            TemplateNode node = new TemplateNode();
            node.id = ics.ResolveVariables("defs.id");
            node.name = ics.ResolveVariables("defs.name");
            node.assetdef= ics.ResolveVariables("templatetypes.assettemplate");
            node.doChildDefs(ics);
            node.print(ics);
            }
        %>
        <br/>
    </ics:listloop>
    <br/>
</ics:listloop>
</cs:ftcs>
