@ECHO OFF
SET nrf_folder=C:\Program Files (x86)\Nordic Semiconductor\nrf5x\bin
SET hex_file="MERGED_FIRMWARE.hex"
SET var_file="VARIABLES.cmd"

IF NOT EXIST %hex_file% echo ERROR: No file '%hex_file%' found & pause & exit 1
IF NOT EXIST %var_file% echo ERROR: No file '%var_file%' found & pause & exit 1
call %var_file%

IF NOT EXIST "%nrf_folder%\nrfjprog.exe" echo "nrfproj.exe not found!!" & pause & exit 1
echo "Uploading Firmware for board: %board_name%"

::goto comment

"%nrf_folder%\nrfjprog.exe" --family NRF52 --eraseall --log
if %errorlevel% neq 0 pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --family NRF52 --program %hex_file% --log
if %errorlevel% neq 0 echo ERROR: An error has occurred while uploading the firmware & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --log --family nRF52 --memwr 0x10001084 --val %board_val%
if %errorlevel% neq 0 echo ERROR: An error has occurred while setting the board version & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --log --family nRF52 --memwr 0x10001088 --val %fam_market_type%
if %errorlevel% neq 0 echo ERROR: An error has occurred while setting the family market and product type & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --log --family nRF52 --memwr 0x1000108c --val %maj_min_patch%
if %errorlevel% neq 0 echo ERROR: An error has occurred while setting the major, minor and revision & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --log --family nRF52 --memwr 0x10001090 --val %prodrun_housingid%
if %errorlevel% neq 0 echo ERROR: An error has occurred while setting the production run and housing ID & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --family nRF52 --memwr 0x0007f000 --val 0x01 --log
if %errorlevel% neq 0 echo ERROR: An error has occurred while noting app as valid & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --family NRF52 --reset --log
if %errorlevel% neq 0 pause & exit /b %errorlevel%

:::comment
::pause
