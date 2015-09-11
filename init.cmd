cd plugin
call sbt publishLocal
cd ..
cd nglib
call sbt ngTagWrapperGen publishLocal
cd ..
sbt lib
