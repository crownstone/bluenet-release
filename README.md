# Bluenet

[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](http://www.gnu.org/licenses/lgpl-3.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Bluenet is the code running on the [Crownstone](http://crownstone.rocks) and Guidestone. Each Crownstone or Guidestone is a node in a network that uses signal strength for indoor localization of smartphones and wearables.

This Repository keeps track of the released version of bluenet. For the code have a look [here](https://github.com/crownstone/bluenet)

# Releases

## Crownstone 2.1.0
- Setup is now a single command.
- RSSI between mesh nodes is now advertised.
- First version of Switchcraft.
- Advertisements now always use the same service UUID, device type is in the payload.
- Writing switch state to flash now (most of the times) takes a few ms instead of >100ms.
- Improved ADC: stable sampling frequency, and detects when a stall happened.
- Fixed bug where UART TX would stop working.

## Crownstone 2.0.2
- If no board version is in UICR, the default hardware board is written.

## Crownstone 2.0.1
- Dimmer state is no longer restored on boot, relay is used instead (to prevent unnecessary relay toggles when crownstone is behind wall switch).
- Switch lock is disabled when enabling dimming. There is no use case for having both enabled.
- Mesh is no longer flooded by state messages: max 1 state message per 3s is sent.
- Fixed bug where relay was toggled when changing dim value while dimming is not available.
- Fixed bug where relay was being turned on/off while already turned on/off when changing dim value.

## Crownstone 2.0.0
- Crownstone IDs are now 1B, this changed a lot of protocol.
- Changed advertisement protocol to include more data.
- Crownstones now send their state over the mesh.
- Crownstones can now be controlled over the mesh.
- Added switch lock.
- Added config to allow dimming.
- Added energy calculation (cleared on reboot though).
- Added binary UART protocol.
- Added dimming to only start X seconds after boot.
- Added IGBT failure detection.

## Crownstone 1.7.1
- Changed soft fuse to turn relay on when IGBTs are overloaded (temperature or current).

## Crownstone 1.7.0
- Dimming now done by trailing edge dimming (currently only works for 50Hz).
- Dimmer state is stored in persistent storage, and restored on boot (currently with a delay of about 2s).
- Overcurrent detection is relaxed to avoid getting triggered by interference. This lead to slower overcurrent detection though (~400ms).
- Fixed bug where a mesh message on an invalid handle would lead to a crash.

## Crownstone 1.6.0
- Added support for boards ACR01B2G and ACR01B6C.

## Bootloader 1.3.0
- Added support for boards ACR01B2G and ACR01B6C.

## Crownstone 1.5.1
- Enabled sharing time via mesh.

## Crownstone 1.5.0
- Added: schedule functionality: the crownstone can be scheduled to turn on/off at certain times.
- Added: configurable soft fuses.
- Added: also reset relay on a factory reset.
- Added: turn on relay after an hour in setup mode, for built-in crownstones.
- Fixed: unset error bit in advertisement when state errors are reset.

## Crownstone 1.4.0
- Use crystal for low frequency clock.

## Crownstone 1.3.3
- Fixed crashes on disconnect.

## Crownstone 1.3.1
- Added safety measures.
- Keep advertising while connected.
- Connections time out when nothing is written (helps against zombie connections from certain phones).
- Added command to increase TX power during setup.

## Guidestone 1.1.0

## Crownstone Plug 1.1.0

## Crownstone Plug 1.0.0

# Copyrights

The copyrights (2014-2017) belongs to the team of Crownstone B.V. and are provided under an noncontagious open-source license:

* Authors: Dominik Egger, Bart van Vliet, Anne van Rossum, Marc Hulscher, Peet van Tooren, Alex de Mulder, Christian Haas
* Date: 27 Jan. 2014
* Triple-licensed: LGPL v3+, Apache, MIT
* Crownstone B.V., http://crownstone.rocks
* Rotterdam, The Netherlands

This code is built on the shoulders of giants. Our special thanks go to Christopher Mason for the initial C++ code base at [http://hg.cmason.com/nrf](http://hg.cmason.com/nrf) and Trond Einar Snekvik, department of Engineering Cybernetics at Norwegian University of Science and Technology (and Nordic Semiconductors) for the meshing functionality ([OpenMesh](https://github.com/NordicSemiconductor/nRF51-ble-bcast-mesh)).
