OPT=-Dsbt.ivy.home=../dist/project/repo/ 
OPT="$OPT -Dlogback.debug=true -Dconfig.trace=loads"
#OPT="$OPT -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
#OPT="$OPT -jvm-debug 5005"
java -version
javac -version
sbt $OPT "$@"

