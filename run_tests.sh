#! /bin/bash

mkdir -p build
cd build
ghdl -a ../src/design_single_process.vhd

for tb in ../test/vhd/*.vhd;
do
    ghdl -a "$tb"
    name="${tb##*/}"
    name="${name%.vhd}"
    echo "------ TEST: $name -------"
    ghdl -e "$name"
    ghdl -r "$name"
    echo "--------------------------------------"
done