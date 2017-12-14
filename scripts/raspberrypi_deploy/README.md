# Raspberry pi deployment scripts

## Install
To do a first-time setup, all you need to do is run the `install_openocd.sh` script. The compilation step will take while.

## Connecting Crownstone to Raspberry pi

Crownstone| Raspberry  pi
--- | ---
3.3V| (do not connect when powering the Crownstone through AC power)
GND| GND
SWD-CLK| BCM24
SWD-IO| BCM25
TX| BCM15
RX| BCM14

## Flashing firmware
In order to flash firmware to a Crownstone, you need to have the following files present in a single dir:

- `openocd.cfg`
- firmware intended to flash to the Crownstone, here called `MERGED_OUTPUT.hex`
- UICR settings file called `VARIABLES.cfg`

   $ mkdir -p /home/pi/dev/bluenet

#### Ubuntu
Copy the config file:

   $ scp openocd.cfg pi@1.2.3.4:/home/pi/dev/bluenet

Then generate the correct UICR config, and copy it:

   $ python flash_UICR_variable_generator.py
   $ scp VARIABLES.cfg pi@1.2.3.4:/home/pi/dev/bluenet

After [compiling the firmware](https://github.com/crownstone/bluenet), run the `combine.sh` script to get a merged hex. Go to the bin dir and then:

   $ scp combined.hex pi@1.2.3.4:/home/pi/dev/bluenet/MERGED_OUTPUT.hex

#### Windows
The `MERGED_OUTPUT.hex` and `VARIABLES.cfg` files can be obtained by running `merge_hex_files.bat` and  `flash_UICR_variable_generator.py` respectively, from the windows_deploy folder.
Follow the instructions found in the README of that folder for more information.


#### Flash

If these 3 files are present in the same dir, all you need to do is run:

   $ sudo openocd

NOTE: the script might hang after a while. It's not perfect yet. You can just stop the process and restart it. This usually makes it work. If the script is properly executed, the script will end on "`shutdown command invoked`"

## Using UART

Install minicom:

   $ sudo apt install minicom

TODO: config minicom (ctrl-a o) to remove dialup code, etc.

Disable login via serial:

   $ sudo raspi-config

Select option *Interfacing options* then option *Serial*, set "login shell over serial" to *No*, and set "serial port hardware enabled" to *Yes*. Exit raspi-config, then reboot the pi.

# Copyrights

The copyrights (2014-2017) belongs to the team of Crownstone B.V. and are provided under an noncontagious open-source license:

* Authors: Dominik Egger, Bart van Vliet, Anne van Rossum, Marc Hulscher, Peet van Tooren, Alex de Mulder, Christian Haas
* Date: 27 Jan. 2014
* Triple-licensed: LGPL v3+, Apache, MIT
* Crownstone B.V., http://crownstone.rocks
* Rotterdam, The Netherlands

This code is built on the shoulders of giants. Our special thanks go to Christopher Mason for the initial C++ code base at [http://hg.cmason.com/nrf](http://hg.cmason.com/nrf) and Trond Einar Snekvik, department of Engineering Cybernetics at Norwegian University of Science and Technology (and Nordic Semiconductors) for the meshing functionality ([OpenMesh](https://github.com/NordicSemiconductor/nRF51-ble-bcast-mesh)).
