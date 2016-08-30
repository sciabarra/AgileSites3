@echo off
cd %~dp0
set BASE=%CD%
set JOPTS=
if exist setenv.bat call setenv.bat
if exist project\setenv.bat call project\setenv.bat
set JAVA=%JAVA_HOME%\bin\java
set LAUNCHER=%BASE%\project\sbt-launch.jar
set SBT=-Xms512m -Xmx2048m -XX:MaxPermSize=256m -Xss1M -XX:+CMSClassUnloadingEnabled %JOPTS% -jar %LAUNCHER%
"%JAVA%" %SBT% %*
