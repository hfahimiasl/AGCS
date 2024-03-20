@echo off
echo Running Deploy Script
cd ../..
cmd /C deploy-win64.bat
title Installer Script
echo Setting up environment
cd ..\build\win64
mkdir installer
cd installer
mkdir config
Xcopy /E /I ..\..\..\Tools\installer\win64\config config\
mkdir packages
Xcopy /E /I ..\..\..\Tools\installer\win64\packages packages\
Xcopy /E /I ..\deploy packages\AGCS\data\
copy ..\..\..\Tools\installer\win64\driver.msi packages\AGCS\data\
echo.
echo Making installer file
C:\Qt\QtIFW-4.0.1\bin\binarycreator.exe --offline-only -c config\config.xml -p packages agcs-installer-win64.exe
echo.
echo Process complete
echo.
pause
