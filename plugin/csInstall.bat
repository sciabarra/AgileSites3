rem
rem Install ContentServer and Applications with Java/Swing GUI
rem
echo off

call ./Sun/common/jVCheck.bat


if "%JAVA_BIN%" == "NULL" goto FAIL

call ./setClasspath.bat 

"%JAVA_BIN%" -Xms128m -Xmx256m -Dorg.apache.commons.httpclient.HttpMethodBase=ERROR -classpath %CORELIBS%;%SUNLIBS% COM.FutureTense.Apps.CSSetup -files cscore.xml,csui.xml,languagepackInstall.xml,avisports.xml,fs2.xml,wemInstall.xml,ucmIntegration.xml %1 %2 %3 %4 %5 %6 %7 %8 %9
if ERRORLEVEL 1 goto ERRORMSG
if not ERRORLEVEL 1 goto DONE
goto DONE

:ERRORMSG
@echo.
@echo.
echo W A R N I N G ! ! ! 
echo The install could not find java.exe in your path.
echo Please check your path and try again.
@echo.
pause
goto DONE


:FAIL
@echo.
echo You do not have write permissions in your HOME directory!
@echo.
echo The Install will now exit when you press a key.
@echo.
pause


:DONE

