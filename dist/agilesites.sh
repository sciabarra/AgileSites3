#!/bin/bash
set -x
cd "$(dirname $0)"
BASE="$(pwd)"
REPO="$BASE/project/repo"
BOOT="$BASE/project/boot"
JAVA="$JAVA_HOME/bin/java"
SBT_JAR="$BASE/project/sbt-launch.jar"
SBT="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M -Dsbt.boot.directory=$BOOT -Dsbt.ivy.home=$REPO -Dsbt.override.build.repos=true -jar $SBT_JAR"
test -e setenv.sh && source setenv.sh
test -e mysetenv.sh && source mysetenv.sh
test -e agilesites.properties || echo "$JAVA" $SBT "ng:configure"
if test -e agilesites.properties 
then "$JAVA" $SBT "$@"
else echo "Configuration not complete. Please rerun this script and complete configuration."
fi
