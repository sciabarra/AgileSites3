<!DOCTYPE html>
<html lang="{{ page.lang }}">
{{ partial('partial/head') }}
<body touch-action="auto">	
	<div id="body">
		{{ partial('partial/header') }}
		{{ body }}
	</div>

	{{ partial('partial/after_footer') }}
</body>
</html>