@echo off
for /F "tokens=1* delims==" %%i in (agilesites.properties) do (
   if "%%i"=="java" set JAVA=%%j
   if "%%i"=="repo" set REPO=%%j
 )
 
if "%REPO%"=="" set REPO=%HOMEDRIVE%%HOMEPATH%.ivy2
set SBT_REPO=%REPO:/=\%
set SBT_JAVA=%JAVA:/=\%
call %~dp0\bin\sbt.cmd %*

