#!/bin/bash
if ! test -e agilesites.properties
then echo "Please create an agilesites.properties and configure it" ; exit 1
fi
SBT_JAVA=$(cat agilesites.properties | grep 'java=' | sed -e 's/^java=//')/bin/java
SBT_REPO=$(cat agilesites.properties | grep 'repo=' | sed -e 's/^repo=//')
if test -z "$SBT_REPO"
then SBT_REPO=~/.ivy2
fi
if test -z "$SBT_JAVA"
then  SBT_JAVA="$JAVA_HOME"/bin/java
fi
export SBT_JAVA SBT_REPO
exec $(dirname $0)/bin/sbt.sh "$@"
