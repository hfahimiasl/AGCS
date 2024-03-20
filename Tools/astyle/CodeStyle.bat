@echo off

title Code Style

cd ../../src

astyle --options=../Tools/astyle/astylerc --preserve-date --recursive *.h *.cpp

echo.
echo Process complete
echo.

pause
