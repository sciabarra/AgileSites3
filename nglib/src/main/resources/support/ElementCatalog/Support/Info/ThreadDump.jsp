<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%
//
// Support/Info/ThreadDump
//
// INPUT
//
// OUTPUT
//
%><%@ page import="java.lang.management.ManagementFactory"
%><%@ page import="java.lang.management.ThreadInfo"
%><%@ page import="java.lang.management.ThreadMXBean"
%><%@ page import="java.util.regex.Pattern"
%><%@ page import="java.lang.Thread.State"
%><%!
private final ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();


private static final char[] INDENT = "    ".toCharArray();

private static final char[] NEW_LINE = "\r\n".toCharArray();


void createThreadDump(StringBuilder sb, int max, State[] states, Pattern p) {
    Thread[] t = new Thread[Thread.activeCount() * 2];

    int count = Thread.enumerate(t);
    for (int i = 0; i < count; i++) {
        if (t[i] != null) {
            if (t[i].getState() == State.BLOCKED){
               sb.append(t[i].getName()).append(" ").append(t[i].getState()).append(NEW_LINE);
                for (StackTraceElement ste : t[i].getStackTrace()) {
                    sb.append(INDENT).append("at ").append(ste.toString());
                    sb.append(NEW_LINE);
                }
                sb.append(NEW_LINE);

                ThreadInfo ti = threadMXBean.getThreadInfo(t[i].getId(),
                        max);
                sb.append(ti.toString()).append(NEW_LINE);

            }
        }
    }

    ThreadInfo[] threadInfos = threadMXBean.dumpAllThreads(true, true);
    //        threadInfos = threadMXBean.getThreadInfo(
    //                threadMXBean.getAllThreadIds(), max);

    for (ThreadInfo ti : threadInfos) {
        State state = ti.getThreadState();
        //sb.append(state).append(NEW_LINE);

        for (State s:states){
           if (s == state && p.matcher(ti.getThreadName()).matches()){
              printThreadInfo(ti, sb,max);
           }
        }

    }

}
void createThreadDumpNative(StringBuilder sb, int max, State[] states, Pattern p) {

    ThreadInfo[] threadInfos = threadMXBean.dumpAllThreads(true, true);

    for (ThreadInfo ti : threadInfos) {
        State state = ti.getThreadState();
        for (State s:states){
           if (s == state && p.matcher(ti.getThreadName()).matches()){
               sb.append(ti.toString()).append(NEW_LINE);
           }
        }

    }

}

private void printThreadInfo(ThreadInfo ti, final StringBuilder sb, int max) {
    long tid = ti.getThreadId();
    sb.append("\"").append(ti.getThreadName()).append("\"").append(" id=").append(tid).append(" in "
           ).append(ti.getThreadState());
    if (ti.getLockName() != null) {
        sb.append(" on lock=").append(ti.getLockName());
    }
    if (ti.isSuspended()) {
        sb.append(" (suspended)");
    }
    if (ti.isInNative()) {
        sb.append(" (running in native)");
    }
    if (ti.getLockOwnerName() != null) {
        sb.append(INDENT).append(" owned by ")
                .append(ti.getLockOwnerName()).append(" id=").append(
                        ti.getLockOwnerId());

    }
    if (threadMXBean.isThreadCpuTimeSupported()) {
        sb.append(NEW_LINE);
        sb.append(" total cpu time=")
                .append( formatNanos(threadMXBean.getThreadCpuTime(tid)));
        sb.append(", user time=").append(
                formatNanos(threadMXBean.getThreadUserTime(tid)));
    }

    if (threadMXBean.isThreadContentionMonitoringSupported() && threadMXBean.isThreadContentionMonitoringEnabled()){
        sb.append(NEW_LINE);
        sb.append(" blocked count=").append(ti.getBlockedCount());
        sb.append(", blocked time=").append(formatNanos(ti.getBlockedTime()));
        sb.append(", wait count=").append(ti.getWaitedCount());
        sb.append(", wait time=").append(formatNanos(ti.getWaitedTime()));
    }

    sb.append(NEW_LINE);
    for (StackTraceElement ste : ti.getStackTrace()) {
        if (--max<0) break;
        sb.append(INDENT).append("at ").append(ste.toString());
        sb.append(NEW_LINE);

    }
    sb.append(NEW_LINE);

}

String formatNanos(long ns) {
    return String.format("%.2f ms", ns / 1000000D);
}
%>
<cs:ftcs><% if (threadMXBean.isThreadContentionMonitoringSupported()&& !threadMXBean.isThreadContentionMonitoringEnabled()){threadMXBean.setThreadContentionMonitoringEnabled(true);}
String m = ics.GetVar("max");
int max= Integer.MAX_VALUE;
State[] states  = Thread.State.values();
String regex =".*";
boolean extended= "true".equals(ics.GetVar("extended"));

if (COM.FutureTense.Interfaces.Utilities.goodString(ics.GetVar("regex"))){
    try {
        regex=ics.GetVar("regex");
    }catch(Exception e){
     //ignore
    }
}

if (COM.FutureTense.Interfaces.Utilities.goodString(ics.GetVar("state"))){
    try {
        //out.println(ics.GetVar("state"));
        String[] s =ics.GetVar("state").split(";");
        states  = new State[s.length];
        for (int i=0; i< s.length;i++){
            states[i]= State.valueOf(s[i]);
        }
    }catch(Exception e){
     //ignore
    }
}

if (COM.FutureTense.Interfaces.Utilities.goodString(m)){
    try {
        max = Integer.parseInt(m);
    }catch(Exception e){
     //ignore
    }
}
StringBuilder str = new StringBuilder(4000);
str.append("Full Thread Dump at ").append(new java.util.Date()).append(NEW_LINE);
if (extended) {
    createThreadDump(str,max,states, Pattern.compile(regex));
} else {
    createThreadDumpNative(str,max,states, Pattern.compile(regex));
}
out.write(str.toString());
%></cs:ftcs>