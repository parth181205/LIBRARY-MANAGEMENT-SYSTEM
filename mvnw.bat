@echo off
setlocal
set "JAVA_HOME=C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"
if exist "%LOCALAPPDATA%\Programs\apache-maven-3.9.9\bin\mvn.cmd" (
    call "%LOCALAPPDATA%\Programs\apache-maven-3.9.9\bin\mvn.cmd" %*
) else (
    call mvn %*
)
