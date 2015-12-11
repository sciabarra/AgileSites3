cd %~dp0
set BASE=%CD%
set REPO=%BASE%\project\repo
set BOOT=%BASE%\project\boot
set JAVA=%JAVA_HOME%\bin\java
set LATEST=http://www.sciabarra.com/agilesites/
set LAUNCHER=%BASE%\project\sbt-launch.jar
set JOPTS=
if exist setenv.bat call setenv.bat
if exist mysetenv.bat call mysetenv.bat
set SBT=-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -Dsbt.boot.directory=%BOOT% -Dsbt.ivy.home=%REPO% -Dagilesites.latest=%LATEST% %JOPTS% -jar %LAUNCHER% 
if not exist agilesites.properties "%JAVA%" %SBT% upgrade update setup reload eclipse
if not exist agilesites.properties goto error
"%JAVA%" %SBT%
goto end
:error
echo Configuration not complete. Please rerun this script and complete configuration.
:end
