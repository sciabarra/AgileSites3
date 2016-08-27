#!/bin/bash
cd "$(dirname $0)"
BASE="$(pwd)"
JAVA="$JAVA_HOME/bin/java"
LAUNCHER="$BASE/project/sbt-launch.jar"
JOPTS=
test -e setenv.sh && source setenv.sh
test -e project/setenv.sh && source project/setenv.sh
SBT="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled $JOPTS -jar $LAUNCHER"
"$JAVA" $SBT "$@"
