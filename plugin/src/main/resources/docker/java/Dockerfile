FROM oraclelinux:7
RUN yum -y update && yum clean all 
COPY jdk.rpm.link .
RUN curl $(cat jdk.rpm.link) >jdk.rpm && rpm -ivh jdk.rpm && rm jdk.rpm
