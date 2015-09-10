<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%//
// Support/Verify/Cluster/FileSystemTest
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="java.io.*"
%><%@ page import="java.util.concurrent.*"
%><%@ page import="java.nio.channels.FileChannel"
%><%@ page import="java.nio.channels.FileLock"
%><%!
static class FileAccessCallable implements Callable<Long>
{
    private File path;
    private int numFiles;
    private byte[] b;
    private int numReads;
    private boolean lock;
    private boolean fileAttr;
    private String rafMode;

    FileAccessCallable( File path, int numFiles, byte[] body, int numReads, boolean lock, boolean fileAttr, String rafMode )
    {
        this.path = path;
        this.numFiles = numFiles;
        this.b = new byte[body.length];
        System.arraycopy(body,0,b,0,b.length);
        this.numReads = numReads;
        this.lock=lock;
        this.rafMode=rafMode;
        this.fileAttr=fileAttr;
    }


    public Long call() throws Exception
    {
        String s = Thread.currentThread().getName();

        // First create the subDir in path
        File dir = new File( path , s );
        dir.mkdirs();
        long startTime = System.nanoTime();
        // Create given # of files
        for( int x = 0; x < numFiles; x++ ) {
            File f = new File( dir, x + ".lock" );
            f.createNewFile();
            FileOutputStream os = new FileOutputStream( f );
            os.write( b );
            os.close();
        }

        // read these files using a RandomAccessFile
        for( int x = 0; x < numFiles; x++ ) {
            File f = new File(dir , x + ".lock");
            // read them a given # of times
            for( int i = 0; i < numReads; i++ ) {
                if (fileAttr) { f.lastModified(); }
                RandomAccessFile ra=null;
                FileChannel channel= null;
                FileLock fLock= null;

                try {
                    ra= new RandomAccessFile( f, rafMode );
                    if (lock){
                        channel= ra.getChannel();
                        fLock= channel.tryLock();
                    }
                        ra.readFully(b);
                    if (fLock !=null){
                        fLock.release();
                    }
                } finally {
                  if (ra !=null) ra.close();
                }
            }
        }


        // delete

        for( int x = 0; x < numFiles; x++ )
        {
            File delFile = new File( dir, x + ".lock" );
            if( delFile.exists() )
            {
                delFile.delete();
            }
        }
        long totalOperations = ((2+numReads)*numFiles);
        long runTime = (System.nanoTime() - startTime)/(totalOperations*1000); //in microsecond per operation
        return runTime;
    }
}

%><cs:ftcs><%
int numThreads = Integer.parseInt(ics.GetVar("numThreads"));
int numFiles = Integer.parseInt(ics.GetVar("numFiles"));
int fileSize = Integer.parseInt(ics.GetVar("fileSize"));
int numReads = Integer.parseInt(ics.GetVar("numReads"));
boolean fileLock = Boolean.parseBoolean(ics.GetVar("filelock"));
boolean fileAttr = Boolean.parseBoolean(ics.GetVar("fileAttr"));
String where = ics.GetVar("type") ==null?"local":ics.GetVar("type");
String rafMode = ics.GetVar("rafMode") ==null?"rws":ics.GetVar("rafMode");

String location= ((File)(getServletConfig().getServletContext().getAttribute("javax.servlet.context.tempdir"))).toString();

if ("sync".equals(where)){
    location = ics.GetProperty("ft.usedisksync");
} else if ("spc".equals(where)){
    location = ics.ResolveVariables("CS.CatalogDir.SystemPageCache");
} else if ("data".equals(where)){
    location = ics.ResolveVariables("CS.CatalogDir.MungoBlobs");
}

if (location == null || location.length()==0 ) {
    throw new ServletException("boohoo, no location");
}else {
    final File path = new File(location, "TestFS-can-be-removed");
    File dir = new File(path, "threads");
    dir.mkdirs();
    StringBuilder sb = new StringBuilder();

    // Create a String of given size (bytes)
    for ( int i = 0; i < fileSize; i++)
    {
        sb.append(",");
    }
    byte[] b = sb.toString().getBytes();
    sb=null;

    ExecutorService service = Executors.newFixedThreadPool( numThreads );

    long startTime = System.nanoTime();

    long maxTime = 0;
    long minTime = Integer.MAX_VALUE;
    long totalTime = 0;
    int runs = 0;


    Future<Long>[] futures = new Future[numThreads];
    try {
        for( int x = 0; x < numThreads; x++ )
        {
            //Get the threadTime returned from call()
            futures[x] = service.submit( new FileAccessCallable( dir, numFiles, b, numReads,fileLock,fileAttr,rafMode ) );
        }

        for( int x = 0; x < numThreads; x++ )
        {
            long threadTime = futures[x].get();
            runs++;
            minTime = Math.min(threadTime,minTime);
            maxTime = Math.max(threadTime,maxTime);;

            totalTime += threadTime;

        }
    }
    catch(ExecutionException e)
    {
        throw new ServletException(e);
    }
    catch(InterruptedException e)
    {
        throw new ServletException(e);
    } finally {
        try
        {
            service.shutdown();
            service.awaitTermination( 60*60, TimeUnit.SECONDS );
        }
        catch (InterruptedException e)
        {
            //ignore
        }

        //Clean up thread directories
        for (File threadDir : dir.listFiles())
        {
            threadDir.delete();
        }
        dir.delete();
    }


    //Get average time
    long averageTime = totalTime / ( runs == 0 ? 1:runs );

    long runTime = (System.nanoTime() - startTime)/1000000;

    %>{where:'<%=where%>',<%
    %>numThreads:<%=Integer.toString(numThreads)%>,<%
    %>numFiles:<%=Integer.toString(numFiles)%>,<%
    %>fileSize:<%=Integer.toString(fileSize)%>,<%
    %>numReads:<%=Integer.toString(numReads)%>,<%
    %>fileLock:<%=Boolean.toString(fileLock)%>,<%
    %>fileAttr:<%=Boolean.toString(fileAttr)%>,<%
    %>minTime:<%=Long.toString(minTime)%>,<%
    %>maxTime:<%=Long.toString(maxTime)%>,<%
    %>averageTime:<%=Long.toString(averageTime)%>,<%
    %>totalTime:<%=Long.toString(totalTime)%>,<%
    %>runTime:<%=Long.toString(runTime)%>}<%
    path.delete();
}
%></cs:ftcs>