#!/bin/bash
cd "$(dirname $0)"
BASE="$(pwd)"
REPO="$BASE/project/repo"
BOOT="$BASE/project/boot"
JAVA="$JAVA_HOME/bin/java"
LATEST=http://www.sciabarra.com/agilesites/
LAUNCHER="$BASE/project/sbt-launch.jar"
JOPTS=
test -e setenv.sh && source setenv.sh
test -e mysetenv.sh && source mysetenv.sh
SBT="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -Dsbt.boot.directory=$BOOT -Dsbt.ivy.home=$REPO -Dagilesites.latest=$LATEST $JOPTS -jar $LAUNCHER"
test -e agilesites.properties || "$JAVA" $SBT "upgrade" "update" "setup" "reload" "eclipse"
if test -e agilesites.properties 
then "$JAVA" $SBT "$@"
else echo "Configuration not complete. Please rerun this script and complete configuration."
fi
