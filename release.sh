#!/bin/bash
set -x
V=${1:?release}
cd $(dirname $0)
echo $V>agilesites.ver
cd starter
zip -u agilesites.zip
cd ..
sbt7 core/clean core/package core/publishLocal
sbt7 api/clean api/package api/publishLocal
sbt7 plg/clean plg/package plg/publishLocal
cp agilesites.ver starter/agilesites.ver
echo please check the release installing locally  in the starter
echo then use publish.sh to publish
#sbt7 plg/publish core/publish api/publish s3-upload
