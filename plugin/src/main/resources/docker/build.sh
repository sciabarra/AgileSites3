BASE=${1:?where the files are in http}
echo >java/jdk.rpm.link \
 $BASE/jdk-8u66-linux-x64.rpm
echo >oracle/oraclexe.rpm.link \
 $BASE/oracle-xe-11.2.0-1.0.x86_64.rpm
echo >weblogic/weblogic.jar.link \
 $BASE/fmw_12.2.1.0.0_infrastructure.jar
echo >sites/sites.jar.link \
 $BASE/fmw_12.2.1.0.0_wcsites_generic.jar
docker build -t sites12c-java java
docker build -t sites12c-oracle oracle
docker build -t sites12c-weblogic weblogic
docker build -t sites12c-sites sites
