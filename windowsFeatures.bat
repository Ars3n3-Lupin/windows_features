:: Hide Command and Set Scope
@echo off
setlocal EnableExtensions

:: Customize Window
title Enable Disable windows feature

:: Menu Options
:: Specify as many as you want, but they must be sequential from 1 with no gaps
:: Step 1. List the Application Names
set "App[1]=Show windows features"
set "App[2]=Show windows features enabled"
set "App[3]=Show windows features disabled"
set "App[4]=Enable windows features"
set "App[5]=Disable windows features"

:: Display the Menu
set "Message="
:Menu
cls
:Menu2
REM %Message% is error message
echo.%Message%
echo.
echo.  Choise option
echo.
set "x=0"
:MenuLoop
set /a "x+=1"
:: set /A mean number
:: The first time is x = 0. Every loop is +1
if defined App[%x%] (
    call echo  %x%. %%App[%x%]%%
    goto MenuLoop
)
echo.
:: Prompt User for Choice
:Prompt
set "Input="
set /p "Input=Select your choice:"

REM :Prompt2
REM set "Input="
REM set /p "Input=You must select your choice:"

:: Validate Input [Remove Special Characters]
if not defined Input goto Prompt
set "Input=%Input:"=%"
set "Input=%Input:^=%"
set "Input=%Input:<=%"
set "Input=%Input:>=%"
set "Input=%Input:&=%"
set "Input=%Input:|=%"
set "Input=%Input:(=%"
set "Input=%Input:)=%"
:: Equals are not allowed in variable names
set "Input=%Input:^==%"
call :Validate %Input%

:: Process Input
call :Process %Input%
goto End


:Validate
set "Next=%2"
if not defined App[%1] (
    set "Message=Invalid Input: %1"
    goto Menu
)
if defined Next shift & goto Validate
goto :eof

:Process
set "Next=%2"
call set "App=%%App[%1]%%"

:: Run netsh
if "%App%" EQU "Show windows features" ( 
	DISM /online /get-features /format:table | more && goto Menu2
)
if "%App%" EQU "Show windows features enabled" ( 
	DISM /online /get-features /format:table | find "Enabled" | more && goto Menu2
)
if "%App%" EQU "Show windows features disabled" ( 
	DISM /online /get-features /format:table | find "Disabled" | more && goto Menu2
)
if "%App%" EQU "Enable windows features" (
	set "featurenames=" && set /p featurenames="set name of the feature for disabling: " && goto EnableWindowsFeatures
)
if "%App%" EQU "Disable windows features" (
	set "featurenames=" && set /p featurenames="set name of the feature for enabling: " && goto DisableWindowsFeatures
)

:: Prevent the command from being processed twice if listed twice.
set "App[%1]="
if defined Next shift & goto Process
goto :eof

:EnableWindowsFeatures
DISM /online /enable-feature /featurename:%featurenames%

:DisableWindowsFeatures
DISM /online /disable-feature /featurename:%featurenames%

:End
endlocal
pause >nul