<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Performance/CPUIntensive
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
<%@ page import="java.io.*"%>

<%!

double staticDoubleTest(double d1, double d2)   {
        double d3 = d1;
        double d4 = d2;
        double d5 = d1;
        double d6 = d2;
        d3 += d4;
        d3 *= d2;
        d3 *= d5;
        d3 -= d6;
        d3 /= d1;
        return d3;
}

void runDoubleTests(Writer out, long repeat)  throws IOException  {
        final double d1 = 1.2345678;
        final double d2 = 0.12345678;
        final double numIterations = 8000000;
        final double numRepeatedTests = 1;
        final double numNoReport = 0;
        double sum=0;

        for(double k=0;k<numRepeatedTests;k++) {
            long time = System.currentTimeMillis();
            sum = 0.0;
            for(double i=0;i<numIterations;i++) {
                sum += staticDoubleTest(d1, d2);
            }
            time = System.currentTimeMillis() - time;
            if (k>=numNoReport)
                out.write("staticDoubleTest" + repeat + " test took "+(time/1000.0f)+" secs    sum = "+sum +"\n");
        }

        if(repeat != 0)
            runDoubleTests(out,repeat-1);
}

%>
<cs:ftcs>
<%
long time = System.currentTimeMillis();
runDoubleTests(out,3);
out.write("Whole test took "+((System.currentTimeMillis() - time)/1000.0f) + " secs\n");
%>
</cs:ftcs>