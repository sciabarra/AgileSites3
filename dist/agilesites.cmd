cd %~dp0
set BASE=%CD%
set REPO=%BASE%\project\repo
set BOOT=%BASE%\project\boot
set JAVA=%JAVA_HOME%\bin\java
set LATEST=http://www.sciabarra.com/agilesites/
set LAUNCHER=%BASE%\project\sbt-launch.jar
if exist setenv.bat call setenv.bat
if exist mysetenv.bat call mysetenv.bat
set SBT=-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M -Dsbt.boot.directory=%BOOT% -Dsbt.ivy.home=%REPO% -Dagilesites.latest=%LATEST% -jar %LAUNCHER%
if not exist agilesites.properties "%JAVA%" %SBT% ngSetup
if not exist agilesites.properties goto error
"%JAVA%" %SBT%
goto end
:error
echo Configuration not complete. Please rerun this script and complete configuration.
:end
