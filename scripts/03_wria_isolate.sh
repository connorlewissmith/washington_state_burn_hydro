#!/bin/bash

# 03_wria_isolate.sh: Isolate all wria shapefiles individually for clipping statewide DEM 

# Paths
output_dir=~/Downloads/wria_shapefiles

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# List of WRIA_NM names
wria_names=(
  "Pend Oreille"
  "Upper Lake Roosevelt"
  "Nooksack"
  "Kettle"
  "Okanogan"
  "Upper Skagit"
  "Methow"
  "San Juan"
  "Colville"
  "Sanpoil"
  "Lower Skagit - Samish"
  "Middle Lake Roosevelt"
  "Lyre - Hoko"
  "Chelan"
  "Soleduc"
  "Stillaguamish"
  "Island"
  "Nespelem"
  "Quilcene - Snow"
  "Elwha - Dungeness"
  "Foster"
  "Little Spokane"
  "Middle Spokane"
  "Wenatchee"
  "Entiat"
  "Lower Spokane"
  "Lower Lake Roosevelt"
  "Grand Coulee"
  "Kitsap"
  "Upper Crab-Wilson"
  "Skokomish - Dosewallips"
  "Moses Coulee"
  "Queets - Quinault"
  "Hangman"
  "Palouse"
  "Upper Yakima"
  "Lower Chehalis"
  "Kennedy - Goldsborough"
  "Lower Crab"
  "Alkali - Squilchuck"
  "Chambers - Clover"
  "Deschutes"
  "Naches"
  "Nisqually"
  "Upper Chehalis"
  "Willapa"
  "Esquatzel Coulee"
  "Middle Snake"
  "Cowlitz"
  "Lower Snake"
  "Lower Yakima"
  "Grays - Elochoman"
  "Walla Walla"
  "Klickitat"
  "Lewis"
  "Rock - Glade"
  "Wind - White Salmon"
  "Salmon - Washougal"
  "Snohomish"
  "Cedar - Sammamish"
  "Duwamish - Green"
  "Puyallup - White"
)

# Loop through each WRIA name
for wria_name in "${wria_names[@]}"; do
    # Clean WRIA name for safe file naming
    safe_name=$(echo "$wria_name" | tr ' ' '_' | tr -cd '[:alnum:]_')

    # Create the shapefile for the current WRIA
    output_shapefile="$output_dir/${safe_name}.shp"
    ogr2ogr -where "WRIA_NM='$wria_name'" "$output_shapefile" "$shapefile"

    echo "Created shapefile for WRIA: $wria_name"
done

echo "All WRIA shapefiles saved in $output_dir"
