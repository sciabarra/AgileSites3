cd plugin
git checkout 11g
sbt publishLocal
cd ..
cd nglib
git checkout 11g
sbt ngTagWrapperGen publishLocal
cd ..
cd setup
git checkout 11g
cd ..
cd bigbang
git checkout 11g
cd ..
sbt lib
