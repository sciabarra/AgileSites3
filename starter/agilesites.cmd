cd %~dp0
set BASE=%CD%
set JAVA=%JAVA_HOME%\bin\java
set LAUNCHER=%BASE%\project\sbt-launch.jar
set JOPTS=
if exist setenv.bat call setenv.bat
if exist project\setenv.bat call project\setenv.bat
set SBT=-Xms1024M -Xmx2048M -Xss1M -XX:+CMSClassUnloadingEnabled %JOPTS% -jar %LAUNCHER%
"%JAVA%" %SBT%
