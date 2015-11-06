#!/bin/bash
set -x
cd "$(dirname $0)"
BASE="$(pwd)"
REPO="$BASE/project/repo"
BOOT="$BASE/project/boot"
JAVA="$JAVA_HOME/bin/java"
LATEST=http://www.sciabarra.com/agilesites/
LAUNCHER="$BASE/project/sbt-launch.jar"
test -e setenv.sh && source setenv.sh
test -e mysetenv.sh && source mysetenv.sh
SBT="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M -Dsbt.boot.directory=$BOOT -Dsbt.ivy.home=$REPO -Dagilesites.latest=$LATEST -jar $LAUNCHER"
test -e agilesites.properties || "$JAVA" $SBT "upgrade" "update" "ng:setup" "reload"
if test -e agilesites.properties 
then "$JAVA" $SBT "$@"
else echo "Configuration not complete. Please rerun this script and complete configuration."
fi
