<head prefix="og: http://ogp.me/ns#">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="description" content="">
<meta name="viewport" content="width=device-width, minimal-ui">
  <title>{% if page.title %}{{ page.title }} | {% endif %}{{ config.title }}</title>

  <!-- Canonical links -->
  <link rel="canonical" href="{{ url }}">
  <!-- Alternative links -->
  {% if page.layout == 'page' or page.layout == 'index' %}
    {% for lang in site.data.languages %}
      <link rel="alternative" hreflang="{{ loop.key }}" href="{{ canonical_url(loop.key) }}">
    {% endfor %}
  {% endif %}
  {% if page.layout == 'index' %}
	<link rel="stylesheet" href="/css/index.css">
  {% endif %}
  <!-- Icon -->
 
  <link rel="icon" type="image/ico" href="{{ url_for('images/favicon/favicon.ico') }}">
  <!-- CSS -->
   <!-- build:css build/css/navy.css -->
  {{ css('css/navy') }}
  <!-- endbuild -->
 <link rel='stylesheet' type='text/css' href='http://fonts.googleapis.com/css?family=Roboto:400,300italic,300,700,400italic,100,100italic'>
    <link rel='stylesheet' type='text/css' href='http://fonts.googleapis.com/css?family=Alegreya+Sans:100'>
    <link rel="stylesheet" href="/css/normalize.css">	
	<link rel="stylesheet" href="/css/html5main.css">
    <link rel="stylesheet" href="/css/font-awesome.min.css">
    <link rel="stylesheet" href="/css/stylemain.css">
  <!-- TOP JS -->
    <script type="text/javascript">
      _locals = {"user":{},"production":true};
    </script>
  <!-- RSS -->
  {{ feed_tag('atom.xml') }}
  <!-- Open Graph -->
  {{ open_graph({
    fb_admins: config.fb_admins,
    twitter_site: config.twitter
  }) }}
  <!-- Swiftype -->
  <meta class="swiftype" name="title" data-type="string" content="{{ page.title || config.title }}">
  <!-- Google Analytics -->
  {{ partial('google_analytics') }}
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.2/modernizr.js"></script>
<script>
	$(window).load(function() {
		// Animate loader off screen
		$(".se-pre-con").fadeOut("slow");;
	});
	</script>
</head>