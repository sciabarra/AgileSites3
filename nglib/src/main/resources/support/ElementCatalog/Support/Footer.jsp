<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
/*
// Support/Footer
//
// INPUT
//
// OUTPUT
*/
%><cs:ftcs><div style="clear:both"></div><script language="JavaScript" type="text/javascript">
function decorateTables(){
    var clsName = 'altClass';
    var tables = document.getElementsByTagName("table");
    for(var t=0;t<tables.length;t++) {
        if(tables[t].className == clsName) {

            var tableBodies = tables[t].getElementsByTagName("tbody");
            <%-- Loop through these tbodies --%>
            for (var i = 0; i < tableBodies.length; i++) {
                <%-- Take the tbody, and get all it's rows --%>
                var tableRows = tableBodies[i].getElementsByTagName("tr");
                <%-- Loop through these rows
                     Start at 1 because we want to leave the heading row untouched --%>
                for (var j = 1; j < tableRows.length; j++) {
                    <%-- Check if j is even, and apply classes for both possible results --%>
                    if ( (j % 2) == 0  ) {
                        tableRows[j].className += " even";
                    } else {
                        tableRows[j].className += " odd";
                    }
                }
            }
        }
    }
}
addEvent(window, 'load', decorateTables);
</script>
<div id="footer"><span style="float:left">Copyright &copy;2003-2013 Oracle Corporation.  All Rights Reserved.</span> <span style="float:right">&nbsp;Version <%= ics.GetVar("st_version") %></span></div>
</cs:ftcs>