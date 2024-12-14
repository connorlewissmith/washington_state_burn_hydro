#!/bin/bash

# 02_dem_merge.sh: Script to merge all DEM raster files in a directory into a single raster.

# Set the directory containing the raster files
input_dir="$HOME/Downloads/usgs_dems"

# Set the output file name
output_raster="$input_dir/merged_dem.tif"

# Use gdal_merge.py to merge all raster files in the directory
gdal_merge.py -o "$output_raster" -of GTiff "$input_dir"/*.tif

echo "Merging complete. Output saved to $output_raster"
