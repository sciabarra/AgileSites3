<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs>Hello World <ics:getvar name="id"/><%

if (ics.GetVar("sleep") !=null){
    long sleep = Long.parseLong(ics.GetVar("sleep"));

    try {
        if (sleep >0) Thread.sleep(sleep);
    }catch(Exception e){
        ics.LogMsg(e.getMessage());
    }
}

COM.FutureTense.Cache.CacheManager.RecordItem(ics, "bogus-"+ ics.GetVar("id"));

%></cs:ftcs>