# ===============================================================================
# AMITY UNIVERSITY NOIDA - LIBRARY MANAGEMENT SYSTEM SERVER LAUNCHER (PowerShell)
# ===============================================================================

$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
$env:CATALINA_HOME = "$PSScriptRoot\tomcat"
$env:CATALINA_BASE = "$PSScriptRoot\tomcat"

if (-not $env:DB_PASSWORD) {
    $pwd = Read-Host "Enter your MySQL root password" -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd)
    $env:DB_PASSWORD = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
}

$env:JAVA_OPTS = "-Ddb.password=$($env:DB_PASSWORD) -Dfile.encoding=UTF-8"

Write-Host ""
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host "   Starting Apache Tomcat 10.1 (Jakarta EE 10 Server)..." -ForegroundColor Yellow
Write-Host "   URL: http://localhost:8080/amity-library/" -ForegroundColor Green
Write-Host "   Press Ctrl+C to stop the server." -ForegroundColor Cyan
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host ""

& "$env:CATALINA_HOME\bin\catalina.bat" run
