var resultLabel;
var resultCursor;

function onLoad() {
  resultLabel = getTagsByName(document, 'span', 'result-label');
  resultCursor = 0;
  runCheck();
}

function resetField( num ) {
  resultLabel[num].innerHTML = "";
  var currTable = resultLabel[num].title;
  document.getElementById(currTable + "-results-a").style.display = 'none';
  document.getElementById(currTable + "-exp-link").style.display = 'none';
  document.getElementById(currTable + "-atype").style.color = '#000000';
}

function rescan( num ) {
  resetField(num);
  resultCursor = 0;
  runCheck();
}

function rescanAll() {
  for (var i = 0; i < resultLabel.length; i++) {
    resetField(i);
  }
  resultCursor = 0;
  runCheck();
}

function getTagsByName ( rootElement, theTag, tagName ) {
  var allTags = rootElement.getElementsByTagName(theTag);
  var arrayCounter = 0;
  var resultArray = new Array();

  for (var i = 0; i < allTags.length; i++) {
    if (allTags[i].getAttribute('name') == tagName) {
      resultArray[arrayCounter] = allTags[i];
      arrayCounter++;
    }
  }
  
  return resultArray;
}

function checkall () {

  var obj = document.forms[0].elements[0];
  var formCnt = obj.form.elements.length;
  
  for (var i=0; i<formCnt; i++) {
    if (obj.form.elements[i].name == "types")  {
      if (document.getElementById("cAll").checked)
        obj.form.elements[i].checked=true;
      else
        obj.form.elements[i].checked=false;
    }
  }
}

function toggleHide ( thisElement, hideType ) {
  var targetElement;
  if (thisElement.id.lastIndexOf("-a") == (thisElement.id.length - 2))
    targetElement = document.getElementById(thisElement.id.substring(0, thisElement.id.lastIndexOf("-a")));
  else
    return;
  
  if (targetElement != null) {
    if (hideType != null) {
      targetElement.style.display = (hideType == 'hide' ? 'none' : '' );
      thisElement.innerHTML = (hideType == 'hide' ? '+' : '-');
    }
    else {
      targetElement.style.display = (targetElement.style.display != 'none' ? 'none' : '' );
      thisElement.innerHTML = (targetElement.style.display != 'none' ? '-' : '+' );
    }
  }
}

function expandAll ( thisElement, theElement, thePrefix ) {
  var hideType = thisElement.title;
  
  var allToggle = getTagsByName(theElement, 'div', 'togglehide');
  var allExpand = getTagsByName(theElement, 'div', 'expand_table');
  var i;
  
  for (i = 0; i < allToggle.length; i++) {
    if (allToggle[i].id.indexOf(thePrefix, 0) == 0 || thePrefix == undefined)
      toggleHide(allToggle[i], hideType);
  }
  
  thisElement.title = (hideType == 'hide') ? 'unhide' : 'hide';
  
  if (thePrefix == undefined) {
    for (i = 0; i < allExpand.length; i++) {
      allExpand[i].title = thisElement.title;
    }
  }
}

function runCheck () {
  if (resultLabel.length > 0)
    document.title = parseInt((resultCursor / resultLabel.length) * 100) + "% - Check Assets";
  
  document.getElementById("title").innerHTML = document.title;
    
  if (resultLabel[resultCursor] == undefined) {
    return;
  }
  
  if (resultLabel[resultCursor].innerHTML != "") {
    resultCursor++;
    runCheck();
  }
  else if (resultLabel.length > resultCursor) {
    resultLabel[resultCursor].innerHTML = "&nbsp;-&nbsp;Scanning... (<a href=\"javascript:void(0);\" onclick=\"rescan(" + resultCursor + ")\">rescan</a>)";
    try {
      makeRequest('ContentServer?pagename=Support/Assets/checkAssetsPost&assettype=' + resultLabel[resultCursor].title);
    }
    catch (e) {
      resultLabel[resultCursor].innerHTML = ' - There was a problem with the request: '+ e.name + ' - ' + e.message;
    }
  }
}

function checkResult(httpRequest) {

  if (httpRequest.readyState == 4) {
    if (httpRequest.status == 200) {
      try {
        parseResult(httpRequest.responseXML);
      }
      catch (e) {
        var err = ("" + e).replace(/\"/g, "&quot;");
        resultLabel[resultCursor].innerHTML = ' - <span title="' + err + '"><font color="red">Error! Please click <a href="ContentServer?pagename=Support/Assets/checkAssetsPost&cs.contenttype=text/html&assettype=' + resultLabel[resultCursor].title + '">here</a> and check logs for more information.</font></span> (<a href="javascript:void(0);" onclick="rescan(' + resultCursor + ')">rescan</a>)';
      }
    } else {
      resultLabel[resultCursor].innerHTML = ' - <font color="red">Error. Please click <a href="ContentServer?pagename=checkAssetsPost&cs.contenttype=text/html&assettype=' + resultLabel[resultCursor].title + '">here</a> and check logs for additional information. (HTTP STATUS=' + httpRequest.status + ')</font> (<a href="javascript:void(0);" onclick="rescan(' + resultCursor + ')">rescan</a>)';
    }
    resultCursor++;
    runCheck();
  }
}

function makeRequest(url) {
  var httpRequest;
  if (window.XMLHttpRequest) { // Mozilla, Safari, IE7...
    httpRequest = new XMLHttpRequest();
    if (httpRequest.overrideMimeType) {
      httpRequest.overrideMimeType('text/xml');
      // See note below about this line
    }
  } 
  else if (window.ActiveXObject) { // IE6 and older
      httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
    try {
    } 
    catch (e) {
      try {
        httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
      } 
      catch (e) {}
    }
  }

  if (!httpRequest) {
    resultLabel[resultCursor].innerHTML = 'Giving up :( Cannot create an XMLHTTP instance';
    return false;
  }
    httpRequest.onreadystatechange = function() { checkResult(httpRequest); };
    httpRequest.open('GET', url, true);
    httpRequest.send('');
}

function parseResult ( theXML ) {
  if (theXML.normalize) theXML.normalize();
  var resultTag = theXML.getElementsByTagName('result');
  var numErr = parseInt(resultTag[0].getAttribute('numerr'));
  
  var dbmismatchTag = theXML.getElementsByTagName('dbmismatch');
  var dbmismatchValue = "";
  if (dbmismatchTag[0].firstChild != null)
    dbmismatchValue = dbmismatchTag[0].firstChild.nodeValue;
  
  var invalidTag = theXML.getElementsByTagName('invalid');
  var invalidNum = 0;
  var invalidValue = "";
  
  if (invalidTag[0].firstChild != null) {
    invalidNum = parseInt(invalidTag[0].getAttribute("num"));
    invalidValue = invalidTag[0].firstChild.nodeValue;
  }
  
  var validTag = theXML.getElementsByTagName('valid');
  var validNum = 0;
  var validValue = "";
  
  if (validTag[0].firstChild != null) {
    validNum = parseInt(validTag[0].getAttribute("num"));
    validValue = validTag[0].firstChild.nodeValue;
  }
  
  var currTable = resultLabel[resultCursor].title;
  
  resultLabel[resultCursor].innerHTML = '&nbsp;-&nbsp;' + ((numErr > 0) ? '<span class="badsum">' + numErr + ' invalid data found!</span>' : '<span class="goodsum">no invalid data found.</span>') + '(<a href="javascript:void(0);" onclick="rescan(' + resultCursor + ')">rescan</a>)';
  document.getElementById(currTable + "-results-a").style.display = '';
  document.getElementById(currTable + "-exp-link").style.display = '';
  
  document.getElementById(currTable + "-dbcheck").innerHTML = (dbmismatchValue != null && dbmismatchValue != "") ? dbmismatchValue : '';
  document.getElementById(currTable + "-dbcheck").style.display = (dbmismatchValue != null && dbmismatchValue != "") ? '' : 'none';
  
  
  document.getElementById(currTable + "-numwrong").innerHTML = (invalidNum > 0) ? invalidNum : '';
  document.getElementById(currTable + "-wrong").innerHTML = (invalidNum > 0) ? invalidValue : '';
  document.getElementById(currTable + "-wrong-tr").style.display = (invalidNum > 0) ? '' : 'none';

  document.getElementById(currTable + "-numcorrect").innerHTML = (validNum > 0) ? validNum : '';
  document.getElementById(currTable + "-correct").innerHTML = (validNum > 0) ? validValue : '';
  document.getElementById(currTable + "-correct-tr").style.display = (validNum > 0) ? '' : 'none';
  
  document.getElementById(currTable + "-noasset").style.display = (validNum == 0 && invalidNum == 0) ? '' : 'none';
  document.getElementById(currTable + "-results-table").style.display = (validNum == 0 && invalidNum == 0) ? 'none' : '';
  
  if (numErr > 0) {
    document.getElementById(currTable).setAttribute('name', 'bad');
  }
  else if (numErr == 0) {
    document.getElementById(currTable).setAttribute('name', 'good');
  }
  else {
    document.getElementById(currTable).setAttribute('name', 'unknown');
  }
  document.getElementById(currTable + '-atype').style.color = (numErr > 0) ? '#FF0000' : '#000000';
}

function setViewType ( type, styleType ) {
  var allGoodTags = getTagsByName(document.getElementById('results'), 'tr',  'good');
  var allBadTags = getTagsByName(document.getElementById('results'), 'tr',  'bad');
  var i;
  
  if (type == "good") {
    for (i = 0; i < allGoodTags.length; i++) {
      if (styleType == '') {
         document.getElementById(allGoodTags[i].id + "-results").style.display == '';
      }
      allGoodTags[i].style.display = styleType;
    }
  }
  else if (type == "bad") {
    for (i = 0; i < allBadTags.length; i++) {
      if (styleType == '') {
         document.getElementById(allBadTags[i].id + "-results").style.display == '';
      }
      allBadTags[i].style.display = styleType;
    }
  }
}

function submitExportPage( idOfOutput, idOfInput ) {
  document.getElementById(idOfOutput).value = document.getElementById(idOfInput).innerHTML;
  return true;  
}