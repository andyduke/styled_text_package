@echo off
setlocal

for %%a in (.) do set currentfolder=%%~na
rem echo %currentfolder%

pkzipc -max -add -dir -excl=zip.cmd -excl=build -excl=build/* -excl=android/.gradle -excl=android/.gradle/* %currentfolder%-%date:~6%-%date:~3,2%-%date:~0,2%.zip *.*

endlocal