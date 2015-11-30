<head prefix="og: http://ogp.me/ns#">
  <meta charset="utf-8">
  <title>{% if page.title %}{{ page.title }} | {% endif %}{{ config.title }}</title>
  <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Canonical links -->
  <link rel="canonical" href="{{ url }}">
  <!-- Alternative links -->
  {% if page.layout == 'page' or page.layout == 'index' %}
    {% for lang in site.data.languages %}
      <link rel="alternative" hreflang="{{ loop.key }}" href="{{ canonical_url(loop.key) }}">
    {% endfor %}
  {% endif %}
  <!-- Icon -->
 
  <link rel="icon" type="image/ico" href="{{ url_for('images/favicon/favicon.ico') }}">
  <meta name="msapplication-TileColor" content="#2f83cd">
  <meta name="msapplication-TileImage" content="{{ url_for('icon/mstile-144x144.png') }}">
  <!-- CSS -->
 <link rel='stylesheet' type='text/css' href='http://fonts.googleapis.com/css?family=Roboto:400,300italic,300,700,400italic,100,100italic'>
    <link rel='stylesheet' type='text/css' href='http://fonts.googleapis.com/css?family=Alegreya+Sans:100'>
    <link rel="stylesheet" href="/css/normalize.css">
    <link rel="stylesheet" href="/css/main.css">
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
</head>