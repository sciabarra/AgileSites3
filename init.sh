#!/usr/bin/env bash
cd plugin
sbt publishLocal
cd ..
cd nglib
sbt ngTagWrapperGen publishLocal
cd ..
sbt lib
