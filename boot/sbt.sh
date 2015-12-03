JOPTS="-Dsbt.ivy.home=../dist/project/repo/"
#JOPTS="$JOPTS -Dlogback.debug=true -Dconfig.trace=loads"
#JOPTS="$JOPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
sbt $JOPTS "$@"
