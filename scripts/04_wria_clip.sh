#!/bin/bash

# 04_wria_clip.sh: clipping statewide DEM to WRIA specific rasters

# Paths
shapefile_dir=~/Downloads/wria_shapefiles
merged_dem=~/Downloads/usgs_dems/merged_dem.tif
output_dir=~/Downloads/usgs_dems/clipped_wrias

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through each WRIA shapefile
for shapefile in "$shapefile_dir"/*.shp; do
    # Extract the base name of the shapefile (without extension)
    base_name=$(basename "$shapefile" .shp)

    # Set the output raster file path
    output_raster="$output_dir/${base_name}_dem.tif"

    # Run gdalwarp to clip the DEM using the current shapefile
    gdalwarp -cutline "$shapefile" -crop_to_cutline -dstnodata -9999 "$merged_dem" "$output_raster"

    echo "Clipped DEM created for WRIA: $base_name"
done

echo "All DEMs clipped and saved to $output_dir"

