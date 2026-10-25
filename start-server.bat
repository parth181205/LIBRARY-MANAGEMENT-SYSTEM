@echo off
setlocal enabledelayedexpansion

title Amity University Noida - Library Management System Server

echo ===============================================================================
echo     AMITY UNIVERSITY NOIDA - CENTRAL LIBRARY MANAGEMENT SYSTEM
echo ===============================================================================
echo.

:: 1. Set Java 21 Home
if exist "C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot" (
    set "JAVA_HOME=C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot"
) else (
    echo [ERROR] Java 21 not found at expected path. Please ensure JDK 17+ is installed.
    pause
    exit /b 1
)

set "PATH=%JAVA_HOME%\bin;%PATH%"
set "CATALINA_HOME=%~dp0tomcat"
set "CATALINA_BASE=%~dp0tomcat"

:: 2. Check MySQL password
if "%DB_PASSWORD%"=="" (
    set /p "DB_PASSWORD=Enter your MySQL root password: "
)

set "JAVA_OPTS=-Ddb.password=%DB_PASSWORD% -Dfile.encoding=UTF-8"

echo.
echo Starting Apache Tomcat 10.1 (Jakarta EE 10)...
echo.
echo Application will be live at:
echo   --^> http://localhost:8080/amity-library/
echo.
echo Press Ctrl+C in this terminal window to stop the server.
echo ===============================================================================
echo.

call "%CATALINA_HOME%\bin\catalina.bat" run
