# Windows deployment scripts

[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](http://www.gnu.org/licenses/lgpl-3.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

These files are used to upload release firmware to the [Crownstone](http://crownstone.rocks) using a JTAG interface.

## Prerequisites
Install nrf5X command line tools for windows. The installer can be found at
https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF52832#Downloads

The batch scripts assume the command line tools are installed in the (default) location:
C:\Program Files (x86)\Nordic Semiconductor\
If this is not the case, please adjust the nrf_folder variable in the scripts to refelct your installation location

## Merging hex files

The `merge_hex_files.bat` file should be in the same folder as the following files to work.
 * Crownstone.hex
 * Bootloader.hex
 * s132_nrf52_2.0.0_softdevice.hex

Since we're using SDK 11.0.0 you need the appropriate softdevice hexfile
You can obtain the `s132_nrf52_2.0.0_softdevice.hex` file from the nordic nrf5x SDK11, downloadable at: http://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v11.x.x/

After executing the batch script, you should see a new file called `MERGED_FIRMWARE.hex`

## flash firmware using JTAG

Before flashing your crownstone you need to select the appropriate `boards.txt` file corresponding to the physical board you intend to flash.
You can find your `boards.txt` file in the boards/ folder.
In order to flash the firmware you need to copy all required files in to a single folder.
The files are:
 * flash_firmware.bat
 * MERGED_FIRMWARE.hex
 * boards.txt

You can then run `flash_firmware.bat` to flash the firmware. If anything goes wrong, please submit a bug report with the log output that is generated.

# Copyrights

The copyrights (2014-2017) belongs to the team of Crownstone B.V. and are provided under an noncontagious open-source license:

* Authors: Dominik Egger, Bart van Vliet, Anne van Rossum, Marc Hulscher, Peet van Tooren, Alex de Mulder, Christian Haas
* Date: 27 Jan. 2014
* Triple-licensed: LGPL v3+, Apache, MIT
* Crownstone B.V., http://crownstone.rocks
* Rotterdam, The Netherlands

This code is built on the shoulders of giants. Our special thanks go to Christopher Mason for the initial C++ code base at [http://hg.cmason.com/nrf](http://hg.cmason.com/nrf) and Trond Einar Snekvik, department of Engineering Cybernetics at Norwegian University of Science and Technology (and Nordic Semiconductors) for the meshing functionality ([OpenMesh](https://github.com/NordicSemiconductor/nRF51-ble-bcast-mesh)).
