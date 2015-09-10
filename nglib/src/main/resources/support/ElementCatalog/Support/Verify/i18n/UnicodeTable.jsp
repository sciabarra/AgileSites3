<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/i18n/UnicodeTable
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
<cs:ftcs>
<%!
class Chart {
    int start=0;
    int end=0;
    String name;
    Chart(int start, int end, String name){
        this.start=start;
        this.end=end;
        this.name=name;
    }
}

static java.util.TreeMap list;

void buildList(){
// original is at http://www.unicode.org/Public/UNIDATA/Blocks.txt

list  = new java.util.TreeMap();
list.put(new Integer(0) ,new Chart(0,127, "Basic Latin"));
list.put(new Integer(128) ,new Chart(128,255, "Latin-1 Supplement"));
list.put(new Integer(256) ,new Chart(256,383, "Latin Extended-A"));
list.put(new Integer(384) ,new Chart(384,591, "Latin Extended-B"));
list.put(new Integer(592) ,new Chart(592,687, "IPA Extensions"));
list.put(new Integer(688) ,new Chart(688,767, "Spacing Modifier Letters"));
list.put(new Integer(768) ,new Chart(768,879, "Combining Diacritical Marks"));
list.put(new Integer(880) ,new Chart(880,1023, "Greek and Coptic"));
list.put(new Integer(1024) ,new Chart(1024,1279, "Cyrillic"));
list.put(new Integer(1280) ,new Chart(1280,1327, "Cyrillic Supplementary"));
list.put(new Integer(1328) ,new Chart(1328,1423, "Armenian"));
list.put(new Integer(1424) ,new Chart(1424,1535, "Hebrew"));
list.put(new Integer(1536) ,new Chart(1536,1791, "Arabic"));
list.put(new Integer(1792) ,new Chart(1792,1871, "Syriac"));
list.put(new Integer(1920) ,new Chart(1920,1983, "Thaana"));
list.put(new Integer(2304) ,new Chart(2304,2431, "Devanagari"));
list.put(new Integer(2432) ,new Chart(2432,2559, "Bengali"));
list.put(new Integer(2560) ,new Chart(2560,2687, "Gurmukhi"));
list.put(new Integer(2688) ,new Chart(2688,2815, "Gujarati"));
list.put(new Integer(2816) ,new Chart(2816,2943, "Oriya"));
list.put(new Integer(2944) ,new Chart(2944,3071, "Tamil"));
list.put(new Integer(3072) ,new Chart(3072,3199, "Telugu"));
list.put(new Integer(3200) ,new Chart(3200,3327, "Kannada"));
list.put(new Integer(3328) ,new Chart(3328,3455, "Malayalam"));
list.put(new Integer(3456) ,new Chart(3456,3583, "Sinhala"));
list.put(new Integer(3584) ,new Chart(3584,3711, "Thai"));
list.put(new Integer(3712) ,new Chart(3712,3839, "Lao"));
list.put(new Integer(3840) ,new Chart(3840,4095, "Tibetan"));
list.put(new Integer(4096) ,new Chart(4096,4255, "Myanmar"));
list.put(new Integer(4256) ,new Chart(4256,4351, "Georgian"));
list.put(new Integer(4352) ,new Chart(4352,4607, "Hangul Jamo"));
list.put(new Integer(4608) ,new Chart(4608,4991, "Ethiopic"));
list.put(new Integer(5024) ,new Chart(5024,5119, "Cherokee"));
list.put(new Integer(5120) ,new Chart(5120,5759, "Unified Canadian Aboriginal Syllabics"));
list.put(new Integer(5760) ,new Chart(5760,5791, "Ogham"));
list.put(new Integer(5792) ,new Chart(5792,5887, "Runic"));
list.put(new Integer(5888) ,new Chart(5888,5919, "Tagalog"));
list.put(new Integer(5920) ,new Chart(5920,5951, "Hanunoo"));
list.put(new Integer(5952) ,new Chart(5952,5983, "Buhid"));
list.put(new Integer(5984) ,new Chart(5984,6015, "Tagbanwa"));
list.put(new Integer(6016) ,new Chart(6016,6143, "Khmer"));
list.put(new Integer(6144) ,new Chart(6144,6319, "Mongolian"));
list.put(new Integer(7680) ,new Chart(7680,7935, "Latin Extended Additional"));
list.put(new Integer(7936) ,new Chart(7936,8191, "Greek Extended"));
list.put(new Integer(8192) ,new Chart(8192,8303, "General Punctuation"));
list.put(new Integer(8304) ,new Chart(8304,8351, "Superscripts and Subscripts"));
list.put(new Integer(8352) ,new Chart(8352,8399, "Currency Symbols"));
list.put(new Integer(8400) ,new Chart(8400,8447, "Combining Diacritical Marks for Symbols"));
list.put(new Integer(8448) ,new Chart(8448,8527, "Letterlike Symbols"));
list.put(new Integer(8528) ,new Chart(8528,8591, "Number Forms"));
list.put(new Integer(8592) ,new Chart(8592,8703, "Arrows"));
list.put(new Integer(8704) ,new Chart(8704,8959, "Mathematical Operators"));
list.put(new Integer(8960) ,new Chart(8960,9215, "Miscellaneous Technical"));
list.put(new Integer(9216) ,new Chart(9216,9279, "Control Pictures"));
list.put(new Integer(9280) ,new Chart(9280,9311, "Optical Character Recognition"));
list.put(new Integer(9312) ,new Chart(9312,9471, "Enclosed Alphanumerics"));
list.put(new Integer(9472) ,new Chart(9472,9599, "Box Drawing"));
list.put(new Integer(9600) ,new Chart(9600,9631, "Block Elements"));
list.put(new Integer(9632) ,new Chart(9632,9727, "Geometric Shapes"));
list.put(new Integer(9728) ,new Chart(9728,9983, "Miscellaneous Symbols"));
list.put(new Integer(9984) ,new Chart(9984,10175, "Dingbats"));
list.put(new Integer(10176) ,new Chart(10176,10223, "Miscellaneous Mathematical Symbols-A"));
list.put(new Integer(10224) ,new Chart(10224,10239, "Supplemental Arrows-A"));
list.put(new Integer(10240) ,new Chart(10240,10495, "Braille Patterns"));
list.put(new Integer(10496) ,new Chart(10496,10623, "Supplemental Arrows-B"));
list.put(new Integer(10624) ,new Chart(10624,10751, "Miscellaneous Mathematical Symbols-B"));
list.put(new Integer(10752) ,new Chart(10752,11007, "Supplemental Mathematical Operators"));
list.put(new Integer(11904) ,new Chart(11904,12031, "CJK Radicals Supplement"));
list.put(new Integer(12032) ,new Chart(12032,12255, "Kangxi Radicals"));
list.put(new Integer(12272) ,new Chart(12272,12287, "Ideographic Description Characters"));
list.put(new Integer(12288) ,new Chart(12288,12351, "CJK Symbols and Punctuation"));
list.put(new Integer(12352) ,new Chart(12352,12447, "Hiragana"));
list.put(new Integer(12448) ,new Chart(12448,12543, "Katakana"));
list.put(new Integer(12544) ,new Chart(12544,12591, "Bopomofo"));
list.put(new Integer(12592) ,new Chart(12592,12687, "Hangul Compatibility Jamo"));
list.put(new Integer(12688) ,new Chart(12688,12703, "Kanbun"));
list.put(new Integer(12704) ,new Chart(12704,12735, "Bopomofo Extended"));
list.put(new Integer(12784) ,new Chart(12784,12799, "Katakana Phonetic Extensions"));
list.put(new Integer(12800) ,new Chart(12800,13055, "Enclosed CJK Letters and Months"));
list.put(new Integer(13056) ,new Chart(13056,13311, "CJK Compatibility"));
list.put(new Integer(13312) ,new Chart(13312,19903, "CJK Unified Ideographs Extension A"));
list.put(new Integer(19968) ,new Chart(19968,40959, "CJK Unified Ideographs"));
list.put(new Integer(40960) ,new Chart(40960,42127, "Yi Syllables"));
list.put(new Integer(42128) ,new Chart(42128,42191, "Yi Radicals"));
list.put(new Integer(44032) ,new Chart(44032,55215, "Hangul Syllables"));
list.put(new Integer(55296) ,new Chart(55296,56191, "High Surrogates"));
list.put(new Integer(56192) ,new Chart(56192,56319, "High Private Use Surrogates"));
list.put(new Integer(56320) ,new Chart(56320,57343, "Low Surrogates"));
list.put(new Integer(57344) ,new Chart(57344,63743, "Private Use Area"));
list.put(new Integer(63744) ,new Chart(63744,64255, "CJK Compatibility Ideographs"));
list.put(new Integer(64256) ,new Chart(64256,64335, "Alphabetic Presentation Forms"));
list.put(new Integer(64336) ,new Chart(64336,65023, "Arabic Presentation Forms-A"));
list.put(new Integer(65024) ,new Chart(65024,65039, "Variation Selectors"));
list.put(new Integer(65056) ,new Chart(65056,65071, "Combining Half Marks"));
list.put(new Integer(65072) ,new Chart(65072,65103, "CJK Compatibility Forms"));
list.put(new Integer(65104) ,new Chart(65104,65135, "Small Form Variants"));
list.put(new Integer(65136) ,new Chart(65136,65279, "Arabic Presentation Forms-B"));
list.put(new Integer(65280) ,new Chart(65280,65519, "Halfwidth and Fullwidth Forms"));
list.put(new Integer(65520) ,new Chart(65520,65535, "Specials"));
list.put(new Integer(66304) ,new Chart(66304,66351, "Old Italic"));
list.put(new Integer(66352) ,new Chart(66352,66383, "Gothic"));
list.put(new Integer(66560) ,new Chart(66560,66639, "Deseret"));
list.put(new Integer(118784) ,new Chart(118784,119039, "Byzantine Musical Symbols"));
list.put(new Integer(119040) ,new Chart(119040,119295, "Musical Symbols"));
list.put(new Integer(119808) ,new Chart(119808,120831, "Mathematical Alphanumeric Symbols"));
list.put(new Integer(131072) ,new Chart(131072,173791, "CJK Unified Ideographs Extension B"));
list.put(new Integer(194560) ,new Chart(194560,195103, "CJK Compatibility Ideographs Supplement"));
list.put(new Integer(917504) ,new Chart(917504,917631, "Tags"));
list.put(new Integer(983040) ,new Chart(983040,1048575, "Supplementary Private Use Area-A"));
list.put(new Integer(1048576) ,new Chart(1048576,1114111, "Supplementary Private Use Area-B"));
}

Chart nextChart(int end){
    java.util.SortedMap tail = list.tailMap(new Integer(end));
    if (tail.isEmpty()) {
        return null;
    } else {
        Integer firstKey = (Integer)tail.firstKey();
        Chart chart = (Chart)tail.get(firstKey);
        return chart;
        //return ((Integer)tail.first()).intValue();
    }
}

%><%

String font ="Arial Unicode MS";

%>
<style type="text/css">
<!--
td {
    font-family: "<%= font %>";
    font-size: 16px;
}
-->
</style>

<%
if (list==null) buildList();
boolean unicodeEscaped="true".equals(request.getParameter("esc"));

int step=20;
int start=0;
try {
    start = Integer.parseInt(request.getParameter("start"),16);
} catch(Exception e){

}
Chart chart = (Chart)list.get(new Integer(start));
Chart nextChart = nextChart(chart.end);

int end = chart.end;//endOfSet(start);
%><h3><center><%= chart.name %> on font <%= font %></center></h3>

From <%= start %> (<%= Integer.toHexString(start).toUpperCase() %>) till <%= end %> (<%= Integer.toHexString(end).toUpperCase() %>), <%=(end-start) %> characters.<br>

<table class="altClass" style="font-family: <%= font %>;font-size: 16px;">
<tr heigth="30" ><th width="30">&nbsp;</th><%
for (int j=0; j< step ; j++){
    %><th width="30"><%= j %></th><%
}
%></tr><%

for (int i=start; i< end ; i=i+step){
%>
<tr heigth="30"><td><b><%=i%></b></td><%
    for (int j=0; j< step ; j++){
        int code = (i+j);
        // Character.getNumericValue(str.charAt(i));
        char c = (char)code;
        //String strCode = "x" + Integer.toHexString(code).toUpperCase();
        String strCode = Integer.toString(code).toUpperCase();

        %><td><%
        if (code < end){
            if (Character.isDefined(c)){// &&!Character.isISOControl(c) ) {
                if (unicodeEscaped)
                    out.write("&#" + strCode + ";");
                else
                    out.write(c);
            } else {
                %>*<%
            }
        } else {
            %>&nbsp;<%
        }
        %></td><%
    }
%></tr>
<% } %>
</table>
<% if (nextChart != null) { %>
    <br/><div class="xright"><a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&#38;cmd=<%=ics.GetVar("cmd") %>&#38;start=<%= Integer.toHexString(nextChart.start).toUpperCase() %>&#38;esc=<%=unicodeEscaped %>'>NextChart</a></div><br>
<% } %>

<br/>Display of an asterisk means that java believes that the character (code point) is not a defined Unicode character.<br>
See also <a href="http://www.w3.org/TR/charmod/" target="_new">Character Model for the World Wide Web 1.0</a><br>
See also <a href="http://www.alanwood.net/unicode/index.html" target="_new">Alan Wood's site</a><br>
See also <a href="http://www.unicode.org/iuc/iuc10/x-utf8.html" target="_new">UTF-8 sample</a><br>
</cs:ftcs>
