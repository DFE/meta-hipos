#!/bin/bash
echo 2 > /sys/class/gpio/export
sleep 1.5
cd /sys/class/gpio/gpio2
echo high > direction
sleep 1.5
echo 0 > value 
sleep 1.5
echo 1 > value 
sleep 1.5
echo 0 > value
sleep 1.5
