# initial setup

## configure

git clone https://github.com/sciabarra/AgileSites11g --recursive

copy AgileSites11g/nglib/agilesites.properties in nglib/agilesites.local.properties 
edit it and set

- sites.webapp to 12c webapp
- sites.home to 11g home (for now!!!)

## initialize

$ cd AgileSites11g/plugin
$ git checkout 11g
$ sbt publishLocal
$ cd ../nglib
$ git checkout 11g
$ sbt ngTagWrapperGen
$ sbt publishLocal
$ cd ..
$ sbt lib

## work
Notes

- if you change the spoon processor you MUST nl/package 
- if you change the services you must import (use lib macro)
- if you change the plugin you must reload (reload or r macor)

Commands:

- bb switch to project bigbang, nl switch to project nglib
- lib imports any changes in the lib
- ng:service op [value=]value [key=value...] invokes a service (try siteid AdminSite)
- ng:spoon invokes spoon
  - run from project bb and
  - remember a nl/package if you change it
  - check output in target/spoon-spool.json
- ng:deploy will run all the deployment (spoon -> akka -> sites)










