BASE=${1:?where the files are in http}
eval $(docker-machine env sites12c)
echo >base-java/jdk.rpm.link \
 $BASE/jdk-8u66-linux-x64.rpm
echo >base-oracle/oraclexe.rpm.link \
 $BASE/oracle-xe-11.2.0-1.0.x86_64.rpm
echo >base-weblogic/weblogic.jar.link \
 $BASE/fmw_12.2.1.0.0_infrastructure.jar
echo >base-sites/sites.jar.link \
 $BASE/fmw_12.2.1.0.0_wcsites_generic.jar
docker build -t sites12c-base-java base-java
docker build -t sites12c-base-weblogic base-weblogic
docker build -t sites12c-base-sites base-sites
docker build -t sites12c-base-oracle base-oracle
docker-compose build
