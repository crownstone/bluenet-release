::@ECHO OFF
SET nrf_folder=C:\Program Files (x86)\Nordic Semiconductor\nrf5x\bin
SET hex_file="MERGED_FIRMWARE.hex"

IF NOT EXIST boards.txt echo ERROR: No file 'boards.txt' found & pause & exit 1
IF NOT EXIST MERGED_FIRMWARE.hex echo ERROR: No file 'MERGED_FIRMWARE.hex' found & pause & exit 1

SET /p board_val=<boards.txt

IF NOT EXIST "%nrf_folder%\nrfjprog.exe" echo "nrfproj.exe not found!!" & pause & exit 1
echo "Uploading Firmware"

"%nrf_folder%\nrfjprog.exe" --family NRF52 --eraseall --log
if %errorlevel% neq 0 pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --family NRF52 --program %hex_file% --log
if %errorlevel% neq 0 echo ERROR: An error has occurred while uploading the firmware & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --log --family nRF52 --memwr 0x10001084 --val %board_val%
if %errorlevel% neq 0 echo ERROR: An error has occurred while setting the board version & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --family nRF52 --memwr 0x0007f000 --val 0x01 --log
if %errorlevel% neq 0 echo ERROR: An error has occurred while noting app as valid & pause & exit /b %errorlevel%

"%nrf_folder%\nrfjprog.exe" --family NRF52 --reset --log
if %errorlevel% neq 0 pause & exit /b %errorlevel%

::pause
