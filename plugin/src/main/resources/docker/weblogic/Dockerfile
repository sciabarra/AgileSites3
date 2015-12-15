FROM sites12c-java
RUN useradd -d /app app
USER app
WORKDIR /app
ADD oraInst.loc /app/oraInst.loc
COPY weblogic.rsp weblogic.jar.link /app/
RUN curl >weblogic.jar $(cat weblogic.jar.link) && java -jar weblogic.jar -responseFile /app/weblogic.rsp -silent -invPtrLoc /app/oraInst.loc ; rm weblogic.jar
