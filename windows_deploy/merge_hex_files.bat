@ECHO OFF
SET nrf_folder=C:\Program Files (x86)\Nordic Semiconductor\nrf5x\bin

IF NOT EXIST bootloader.hex 					echo ERROR: No file 'bootloader.hex' found & pause & exit 1
IF NOT EXIST crownstone.hex 					echo ERROR: No file 'crownstone.hex' found & pause & exit 1
IF NOT EXIST s132_nrf52_2.0.0_softdevice.hex 	echo ERROR: No file 's132_nrf52_2.0.0_softdevice.hex' found & pause & exit 1

IF NOT EXIST "%nrf_folder%\mergehex.exe" echo "mergehex.exe not found!!" & pause & exit 1

echo "Merging HEX files"
"%nrf_folder%\mergehex" --merge s132_nrf52_2.0.0_softdevice.hex bootloader.hex --output SD_BL.hex
"%nrf_folder%\mergehex" --merge SD_BL.hex crownstone.hex --output MERGED_FIRMWARE.hex
del SD_BL.hex
if %errorlevel% neq 0 echo ERROR: An error has occurred during HEX-file merging & pause & exit /b %errorlevel%

pause
