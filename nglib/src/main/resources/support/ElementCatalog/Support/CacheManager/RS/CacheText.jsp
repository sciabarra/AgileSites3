<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/CacheManager/RS/Cache
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="COM.FutureTense.Util.*"
%><%@ page import="com.fatwire.cs.core.cache.RuntimeCacheStats"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><cs:ftcs><%

DateFormat df = new SimpleDateFormat("yy/MM/dd HH:mm:ss");
Date now = new Date();
Set hashes = ftTimedHashtable.getAllCacheNames();
int i=1;
for (Iterator itor = hashes.iterator(); itor.hasNext();){
      String key = (String)itor.next();
      ftTimedHashtable ht = ftTimedHashtable.findHash(key);
      if (ht != null) {
          %><%= Long.toString(now.getTime()) %>,<%
          %><%= key %>,<%
          RuntimeCacheStats stats = ht.getRuntimeStats();
          %><%= ht.size() %>,<%
          %><%= stats.getHits()%>,<%
          %><%= stats.getMisses()%>,<%
          %><%= stats.getRemoveCount()%>,<%
          %><%= stats.getClearCount()%>,<%
          %><%= ht.getCapacity() %>,<%
          %><%= stats.getCreatedDate().getTime() %>,<%
          %><%= stats.getLastPrunedDate().getTime() %>,<%
          %><%= stats.getLastFlushedDate().getTime()%>,<%
          %><%= ht.getTimeout()%>,<%
          %><%= ht.getCacheExpiresWhenEmpty()%>,<%
          %><%= ht.getCacheItemsExpireWhenIdle()%>,<%
          %><%= stats.hasINotifyObjects() %>,<%
          %><%= ht.getLinks().size() %><%
      }
      %>
<% }
%></cs:ftcs>