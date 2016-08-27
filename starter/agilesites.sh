#!/bin/bash
cd "$(dirname $0)"
JOPTS=
BASE="$(pwd)"
test -e setenv.sh && source setenv.sh
test -e project/setenv.sh && source project/setenv.sh
JAVA="$JAVA_HOME/bin/java"
LAUNCHER="$BASE/project/sbt-launch.jar"
SBT="-Xms512m -Xmx4096m -Xss1M -XX:+CMSClassUnloadingEnabled $JOPTS -jar $LAUNCHER"
"$JAVA" $SBT "$@"
