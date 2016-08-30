#!/bin/bash
V=${1:?release}
cd $(basename $0)
echo $V>agilesites.ver
cd starter
zip -u agilesites.zip
cd ..
sbt7 plg/publishLocal core/publishLocal api/publishLocal
sbt7 plg/publish core/publish api/publish s3-upload
