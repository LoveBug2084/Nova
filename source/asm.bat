@echo off

rem -----------------------------------------------------------------------------------------
rem  read project name and current build number, create build number text with leading zeros
rem -----------------------------------------------------------------------------------------

set /p bbcProjectName=<projectname.txt
set /p bbcProjectBuildText=<build.txt
set "bbcProjectBuildBin=00000%bbcProjectBuildText%"
set "bbcProjectBuildBin=%bbcProjectBuildBin:~-6%"
echo %bbcProjectBuildBin%>build.bin



rem ---------------
rem  build project
rem ---------------

echo.
beebasm -title "%bbcProjectName%" -v -i build.asm -do "%bbcProjectName%.ssd" -opt 3 -dd -labels labels.txt > listing.txt
if NOT %ERRORLEVEL% == 0 exit /b %ERRORLEVEL%



rem --------------------------------------------------
rem  increment build number
rem --------------------------------------------------

echo.
echo %bbcProjectName% build %bbcProjectBuildBin%
set /a bbcProjectBuildText+=1
echo %bbcProjectBuildText%>build.txt
echo.


rem --------------------------------------------------
rem  update README.md with new build number
rem --------------------------------------------------

echo **Build %bbcProjectBuildBin% - %DATE%**> ..\readme.build.md
for /f "skip=1 tokens=*" %%s in (..\README.md) do (
	echo %%s>> ..\readme.build.md
	)
del /q ..\README.md
ren ..\readme.build.md README.md



rem --------------------------------------------------
rem  run the new build
rem --------------------------------------------------

call run.bat


