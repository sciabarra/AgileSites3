<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%
//
// Support/Verify/Cluster/TestFS
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="java.util.*"
%><%@ page import="java.io.*"
%><%!

String hostname="unknown";
public void jspInit(){
    try {
       hostname = java.net.InetAddress.getLocalHost().getHostName();
    } catch (java.net.UnknownHostException e){}
}

%><cs:ftcs><script type="text/javascript" src="http://www.google.com/jsapi"></script>
<h3>File System Test</h3>
<p>This tool tests the performance of the shared file systems. The results of the tests will give an indication of the relative performance of the shared file system versus local filesystem. This is most useful when tuning various NFS settings.</p>
<div id="message" style="display: none"><img id="loadingimg" src="js/dojox/image/resources/images/loading.gif" onerror="this.remove();"/><b id="messageText">Running File System Tests. Please wait...</b></div>
<div id="controlPanel"><input id="controlButton" type="button" value="Start FileSystemTest" onclick="fsTest.submitTest();"/>
<input type="radio" name="testsize" value="short" id="shorttest"/> Short test
<input type="radio" name="testsize" value="medium" id="mediumtest" checked="checked"/> Medium test
<input type="radio" name="testsize" value="extensive" id="exttest"/> Extensive test
</div>
<div id="visualization"></div>
<script type="text/javascript">if (typeof google == 'undefined'){  $('visualization').remove();}</script>

<table id="resultsTable" style="visibility: hidden"><tbody id="resultsbody">
<tr><th colspan="8">Test</th><th colspan="4">Results</th></tr>
<tr><th>threads</th><th>files</th><th>size</th><th>reads</th><th>lock</th><th>attributes</th><th>raf mode</th><th>where</th>
<th>min</th><th>max</th><th>average</th><th>run</th></tr>
</tbody>
</table>
<div id="labelInstruction" style='display: none'>
The letters in the labels on the graph or table mean the following:
<ul><li>t: number of concurrent threads</li>
<li>f: number of files created,read and deleted</li>
<li>s: the size of each file in bytes</li>
<li>r: the number of times a file is read.</li>
<li>l: will file be locked.</li>
<li>a: will fileattributes be read.</li>
<li>m: the mode to open the RandomAccessFile in.</li>
<li>-type: the type of the folder.</li></ul>
t10-f100-s1024-r100-ltrue-atrue-mrws-data, means that 10 threads each create 100 files of 1024 bytes, get file attributes of those files, read those files 100 times in 'rws' mode while locking them and then delete the files from the 'data' folder.
The Average time reported is the average time in microseconds that a thread takes to complete the operation of 100 files creating, reading 100 times, and then deleting per operation. Operations are creating, reading and deleting a file.
The different folder types are:
<ul>
<li>local: the servlet context temp folder.</li>
<li>sync: usedisksync folder from futuretense.ini.</li>
<li>data: the MungoBlobs or ccurl folder.</li>
<li>spc: the SystemPageCache folder.</li>
</ul>
</div>
<script type="text/javascript">
var iCounter=0;
var fsTest = {
    test: {
        version:'2.0',
        timestamp: new Date(),
        hostname:'<%=hostname %>',
        username: 'unknown',
        cs_environment: window.csEnv,
        results: []
    },

    state:0,
    data:null,
    chart:null,

    addTests: function addTests(threads,files,sizes,reads,locations, fileLock, fileAttr,rafMode){
        var ret=[];
        for (var t=0; t<threads.length;t++){
            for (var f=0; f<files.length;f++){
                for (var s=0; s<sizes.length;s++){
                    for (var r=0; r< reads.length;r++){
                       for (var l=0; l<fileLock.length;l++){
                           for (var a=0; a<fileAttr.length;a++){
                               for (var mo=0; mo<rafMode.length;mo++){
                                   for (var w=0; w<locations.length;w++){
                                        var m ={};
                                        m.thread=threads[t];
                                        m.files=files[f];
                                        m.size=sizes[s];
                                        m.reads=reads[r];
                                        m.where = locations[w];
                                        m.fileLock = fileLock[l];
                                        m.fileAttr = fileAttr[a];
                                        m.rafMode = rafMode[mo];
                                        ret.push(m);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return ret;
    },

    drawChart: function () {
        fsTest.state=1;
        // Create the visualization.
        fsTest.chart = new google.visualization.ColumnChart($('visualization'));
        fsTest.data = new google.visualization.DataTable();
        fsTest.data.addColumn('string', 'Test','test');
        fsTest.data.addColumn('number', 'Average in microseconds','avg');
    },

    stopTest: function(msg){
        if (window.console) console.log('stopTest' + msg +' ' + fsTest.state);
        if(fsTest.state !=2) return;
        fsTest.state=3;
        $('message').update(msg);
        $('controlPanel').style.display='none';


    },
    submitTest: function(){
        if (fsTest.state !=1) return;

        if ($('shorttest').checked){
            fsTest.sampleResult=fsTest.addTests([10],[10,100],[100,10240],[10],["local","data","spc","sync"],[true],[false],["r"]);
        } else if ($('mediumtest').checked){
            fsTest.sampleResult=fsTest.addTests([10],[10,100],[100,10240],[1,50],["local","data","spc","sync"],[true,false],[true],["r"]);
        }else {
            fsTest.sampleResult=fsTest.addTests([10,25],[10,100],[100,10240],[1,10,50],["local","data","spc","sync"],[true,false],[true,false],["r","rw","rws"]);
        }
        $('shorttest').disabled=true;
        $('mediumtest').disabled=true;
        $('exttest').disabled=true;
        fsTest.test.timestamp = new Date();
        fsTest.state=2;
        if (typeof google != 'undefined'){
            $('visualization').style.width='90%'
            $('visualization').style.height='300px';
        }

        $('message').style.visibility='visible';
        $('message').style.display='block';

        $('labelInstruction').style.display='block';

        var button = $('controlButton');
        button.value="Stop File System Test";
        button.onclick = function(){fsTest.stopTest('User stopped test');};

        if (fsTest.sampleResult.length>0) fsTest.runTest(0);
        return true;
    },
    runTest: function(i){
        if (fsTest.state!=2) return;
        var mytest = fsTest.sampleResult[i];
        var label= 't' + mytest.thread +'-f'+mytest.files + '-s' + mytest.size + '-r'+mytest.reads +'-l'+mytest.fileLock+'-a'+mytest.fileAttr+'-m'+mytest.rafMode+'-'+mytest.where;

        $('messageText').update('Running File System Test ('+ i + ' of ' + (fsTest.sampleResult.length ) +'): ' +label +'. Please wait...');

        $('message').style.visibility='visible';
        $('resultsTable').style.visibility='visible';
        new Ajax.Request('ContentServer', {
          method: 'get',
          parameters: {pagename:'Support/Verify/Cluster/FileSystemTest',numThreads: mytest.thread, numFiles: mytest.files,fileSize: mytest.size,numReads:mytest.reads,type:mytest.where,fileLock:mytest.fileLock,fileAttr:mytest.fileAttr,rafMode:mytest.rafMode},
          onSuccess: function(response){
               var result = response.responseText.evalJSON();
               fsTest.test.results.push(result);

               var row= [{v: label},{v: result.averageTime} /*, {v: mytest.avg} */];
               if (typeof fsTest.data != 'undefined'){
                    fsTest.data.addRow(row);
                    // Draw the visualization.
                    try {
                      fsTest.chart.draw(fsTest.data, null);
                    } catch (e){
                      if (window.console) console.log(e);
                    }
               }
               try {
                fsTest.addTableRow(i,label,mytest,result);
               } catch (e){
                 if (window.console) console.log(e);
               }
               i++;
               if (i < fsTest.sampleResult.length) { fsTest.runTest(i);} else { fsTest.finishTest();}
          },
          onFailure: function(){ fsTest.stopTest('Something went wrong...') }

        });
    },

    finishTest: function (){
        fsTest.state=3;
        $('message').style.display='none';
        $('controlButton').style.display='none';

    },
    addTableRow :function addTableRow(rownum,label,mytest,result){
        var tr = $('resultsbody').insertRow(2);
        tr.insertCell(-1).appendChild( document.createTextNode('' + mytest.thread) );
        tr.insertCell(-1).appendChild( document.createTextNode('' + mytest.files) );
        tr.insertCell(-1).appendChild( document.createTextNode('' + mytest.size) );
        tr.insertCell(-1).appendChild( document.createTextNode('' + mytest.reads) );
        tr.insertCell(-1).appendChild( document.createTextNode('' + mytest.fileLock) );
        tr.insertCell(-1).appendChild( document.createTextNode('' + mytest.fileAttr) );
        tr.insertCell(-1).appendChild( document.createTextNode('' + mytest.rafMode) );
        tr.insertCell(-1).appendChild( document.createTextNode('' + mytest.where) );
        tr.insertCell(-1).appendChild( document.createTextNode('' + result.minTime));
        tr.insertCell(-1).appendChild( document.createTextNode('' + result.maxTime));
        tr.insertCell(-1).appendChild( document.createTextNode('' + result.averageTime));
        tr.insertCell(-1).appendChild( document.createTextNode('' + result.runTime));
    }
};

if (typeof google != 'undefined'){
    google.load('visualization', '1', {packages: ['columnchart']});
    google.setOnLoadCallback(fsTest.drawChart);
} else {
    fsTest.state=1;
}
</script>
</cs:ftcs>