@echo off
title Deploy Script
echo Setting up environment
set PATH=C:\Qt\Qt5.12.6\5.12.6\mingw73_64\bin;C:/Qt/Qt5.12.6/Tools/mingw730_64\bin;%PATH%
cd ..
mkdir build
cd build
mkdir win64
cd win64
mkdir native
mkdir deploy
cd native
echo Running Qmake
qmake.exe ..\..\..\AGCS.pro -spec win32-g++ "CONFIG+=qtquickcompiler" && mingw32-make.exe qmake_all
echo Running Make
mingw32-make.exe -j8
echo Running Windeployqt
cd release
copy AGCS.exe ..\..\deploy
cd ..\..\deploy
windeployqt.exe AGCS.exe --release --force --compiler-runtime --qmldir ..\..\..\
echo Adding OpenSSL
copy ..\..\..\libs\openssl\win64\*.dll .
cd ..
@REM zip -r AGCS.zip deploy
echo.
echo Process complete
echo.
pause
