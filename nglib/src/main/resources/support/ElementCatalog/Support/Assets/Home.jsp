<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/Assets/Home
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<div class="low-risk">&nbsp;</div>
<div class="medium-risk">
<ul class="entry-header">
<li class="with-care">
         <h2><a href='ContentServer?pagename=Support/Assets/CheckedOut'><b>CheckedOut</b></a></h2>
         <p>Lists all the checkout assets.</p>
    </li>
</ul>
</div>
<div class="high-risk">
<ul class="entry-header">
<li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/Assets/BulkSaveAssets'><b>BulkSaveAssets</b></a></h2>
         <p>Allows to bulk load, save or void assets based on a entered query.</p>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/Assets/checkAssets'><b>checkAssets</b></a></h2>
         <p>Checks for assets integrity.</p>
         <ul>
         <li>Checks to see if table exists in the DB</li>
         <li>Compares column length with values in ADF (or futuretense.ini if it is a flex asset)</li>
         <li>Does an &lt;asset:load&gt; and &lt;asset:scatter&gt;</li>
         <li>Checks for a corresponding SitePlanTree row for Page assets</li>
         <li>Checks for corresponding ElementCatalog row for CSElement, Template, and SiteEntry</li>
         <li>Checks for corresponding SiteCatalog row for SiteEntry and Templates</li>
         <li>Checks for corresponding MungoBlob row (or _Mungo)</li>
         <li>Checks for missing files</li>
         </ul>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/Assets/ScatterAsset'><b>ScatterAsset</b></a></h2>
         <p>Loads and scatters an asset for inspection.</p>
    </li>
</ul>
</div>
</cs:ftcs>
