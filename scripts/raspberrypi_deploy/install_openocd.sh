#!/bin/bash

#https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi/compiling-openocd#
sudo apt-get install git autoconf libtool make pkg-config libusb-1.0-0 libusb-1.0-0-dev

# added for openocd upload script
sudo apt-get install telnet

#mkdir /home/pi/gits
cd /home/pi/gits

git clone git://git.code.sf.net/p/openocd/code openocd-code

cd openocd-code
./bootstrap

./configure --enable-sysfsgpio --enable-bcm2835gpio

make && sudo make install
