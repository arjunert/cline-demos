@echo off
setlocal ENABLEEXTENSIONS

rem Lightweight Maven wrapper for Windows (downloads Maven locally if missing)

set "MAVEN_VERSION=3.9.9"
set "BASE_DIR=%~dp0"
set "TOOLS_DIR=%BASE_DIR%.tools"
set "MAVEN_DIR=%TOOLS_DIR%\apache-maven-%MAVEN_VERSION%"
set "MAVEN_ZIP=%TOOLS_DIR%\apache-maven.zip"
set "MAVEN_URL_PRIMARY=https://downloads.apache.org/maven/maven-3/%MAVEN_VERSION%/binaries/apache-maven-%MAVEN_VERSION%-bin.zip"
set "MAVEN_URL_FALLBACK=https://archive.apache.org/dist/maven/maven-3/%MAVEN_VERSION%/binaries/apache-maven-%MAVEN_VERSION%-bin.zip"

if exist "%MAVEN_DIR%\bin\mvn.cmd" goto run

echo [mvnw] Maven %MAVEN_VERSION% not found locally. Downloading to "%MAVEN_DIR%"...
if not exist "%TOOLS_DIR%" mkdir "%TOOLS_DIR%"

rem Single-line PowerShell to download (with fallback) and extract without relying on Expand-Archive
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $out='%MAVEN_ZIP%'; try { Invoke-WebRequest -Uri '%MAVEN_URL_PRIMARY%' -OutFile $out -UseBasicParsing } catch { Invoke-WebRequest -Uri '%MAVEN_URL_FALLBACK%' -OutFile $out -UseBasicParsing }; Add-Type -AssemblyName System.IO.Compression.FileSystem; if (Test-Path '%MAVEN_DIR%') { Remove-Item -LiteralPath '%MAVEN_DIR%' -Recurse -Force -ErrorAction SilentlyContinue }; [System.IO.Compression.ZipFile]::ExtractToDirectory('%TOOLS_DIR%\apache-maven.zip', '%TOOLS_DIR%');"

if errorlevel 1 (
  echo [mvnw] Failed to download or extract Maven. >&2
  exit /b 1
)

:run
set "MAVEN_HOME=%MAVEN_DIR%"
set "PATH=%MAVEN_HOME%\bin;%PATH%"

"%MAVEN_HOME%\bin\mvn.cmd" %*
exit /b %ERRORLEVEL%
