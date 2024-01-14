@echo off
setlocal enabledelayedexpansion

rem Step 1: Get the current directory and script file name
for %%A in ("%~dp0\.") do set "folder=%%~fA"
set "script_name=%~nx0"

rem Step 2: Iterate through all files in the folder
for %%F in ("%folder%\*") do (
    rem Step 3: Check if the file is the script file
    if /I not "%%~nxF"=="%script_name%" (
        rem Step 4: Extract the file name and extension
        set "filename=%%~nF"
        set "extension=%%~xF"

        rem Step 5: Replace spaces with -s
        set "filename=!filename: =-s!"

        rem Step 6: Rename the file with the new prefix and modified name
        ren "%%F" "consumption2024-!filename!!extension!"
    )
)

echo File renaming completed.