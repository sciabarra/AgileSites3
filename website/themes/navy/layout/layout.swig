<!DOCTYPE html>
<!--[if lt IE 9]>
  <html class="ie ie-lt9" lang="en">
<![endif]-->
<!--[if IE 9]>
  <html class="ie ie-9" lang="en">
<![endif]-->
<!--[if gt IE 9]><!-->
<html lang="{{ page.lang }}">
{{ partial('partial/head') }}
<body class="noAnimation" touch-action="auto">	
<div class="se-pre-con"></div>
	<div id="body">
		{{ partial('partial/header') }}
		{{ body }}
	</div>

  {{ partial('partial/mobile_nav') }}
	{{ partial('partial/after_footer') }}
</body>
</html>