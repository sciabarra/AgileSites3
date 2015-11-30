<!-- Scripts -->

<!-- build:js build/js/main.js -->
{{ js('js/jquery.min') }}
{{ js('js/skrollr.min') }}
{{ js('js/mobile_nav') }}
<!-- endbuild -->
<script type="text/javascript">
$(document).ready(function(){
    if (/Android|BlackBerry|iPhone|iPad|iPod|webOS/i.test(navigator.userAgent) === false) {		
			var s = skrollr.init();
			window.onload=function(){s.refresh()};
	}
});
</script>

