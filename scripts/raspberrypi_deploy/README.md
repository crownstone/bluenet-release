# Raspberry pi deployment scripts

## install
To do a first-time setup, all you need to do is run the `install_openocd.sh` script. This will take a while, so you might want to get a cup of coffe.

## connecting Crownstone to Raspberry pi

Crownstone| Raspberry  pi
--- | ---
3.3V| (do not connect when powering the Crownstone through AC power)
GND| GND
SWD-CLK| BCM24
SWD-IO| BCM25
TX| BCM15
RX| BCM14

## flashing firmware
In order to flash firmware to a Crownstone, you need to have the following files present in a single folder:
 - `openocd.cfg`
 - firmware intended to flash to the Crownstone, here called `MERGED_OUTPUT.hex`
 - UICR settings file called `VARIABLES.cfg`
 
 At the moment, the `MERGED_OUTPUT.hex` and `VARIABLES.cfg` files can only be obtained by running `merge_hex_files.bat` and  `flash_UICR_variable_generator.py` respectively, from the windows_deploy folder. 
 Follow the instructions found in the README of that folder for more information.
 
 If these 3 files are present in the same folder, all you need to do is run:
 `$ openocd`
 NOTE: you need to be root to properly execute openocd
 NOTE2: the script might hang after a while. It's not perfect yet. You can just stop the process and restart it. this usually makes it work. If the script is properly executed, the script will end on "`shutdown command invoked`"

# Copyrights

The copyrights (2014-2017) belongs to the team of Crownstone B.V. and are provided under an noncontagious open-source license:

* Authors: Dominik Egger, Bart van Vliet, Anne van Rossum, Marc Hulscher, Peet van Tooren, Alex de Mulder, Christian Haas
* Date: 27 Jan. 2014
* Triple-licensed: LGPL v3+, Apache, MIT
* Crownstone B.V., http://crownstone.rocks
* Rotterdam, The Netherlands

This code is built on the shoulders of giants. Our special thanks go to Christopher Mason for the initial C++ code base at [http://hg.cmason.com/nrf](http://hg.cmason.com/nrf) and Trond Einar Snekvik, department of Engineering Cybernetics at Norwegian University of Science and Technology (and Nordic Semiconductors) for the meshing functionality ([OpenMesh](https://github.com/NordicSemiconductor/nRF51-ble-bcast-mesh)).
