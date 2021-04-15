#!/bin/bash
# Split an SVG into layers for usage in reveal.js
# This script creates a subfolder named according to the filename of the provided svg.
# Afterwards for each layer in the SVG file corresponding files will be created within the subfolder, e.g. for filename.svg:
# filename/layer1.svg
# filename/layer1.png
# filename/layer2.svg
# filename/layer2.png
# ...
# The script is currently configured to produce svg files and png files only, but other formats could be added below.
# A. Schlemmer, 09/2020

# Filename:
FN=$1
DN=${FN%.svg}

mkdir -p $DN

n=1
for l in $(inkscape --query-all $FN 2>/dev/null | grep layer | awk -F ',' '{print $1}') ; do
    zn=$(printf %03d $n)
    inkscape -C -j -i $l -o $DN/layer$zn.svg $FN 2>/dev/null
    inkscape -C -j -i $l -o $DN/layer$zn.png $FN 2>/dev/null
    n=$(echo "$n+1" | bc)
done


