#!/bin/bash

# 01_pull_all_dems.sh: downloads Washington statewide USGS DEMs

# Directory to save the downloaded files
output_dir="$HOME/Downloads/usgs_dems"
mkdir -p "$output_dir"

# List of URLs to download
urls=(
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w116/USGS_13_n46w116_20220309.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w117/USGS_13_n46w117_20240401.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w118/USGS_13_n46w118_20240401.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w119/USGS_13_n46w119_20240416.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w120/USGS_13_n46w120_20240416.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w121/USGS_13_n46w121_20221128.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w122/USGS_13_n46w122_20211129.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w123/USGS_13_n46w123_20240124.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w124/USGS_13_n46w124_20240124.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n46w125/USGS_13_n46w125_20130911.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w116/USGS_13_n47w116_20241115.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w117/USGS_13_n47w117_20240401.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w118/USGS_13_n47w118_20240401.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w119/USGS_13_n47w119_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w120/USGS_13_n47w120_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w121/USGS_13_n47w121_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w122/USGS_13_n47w122_20220919.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w123/USGS_13_n47w123_20230608.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w124/USGS_13_n47w124_20240327.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n47w125/USGS_13_n47w125_20240327.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w116/USGS_13_n48w116_20241115.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w117/USGS_13_n48w117_20240507.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w118/USGS_13_n48w118_20240918.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w119/USGS_13_n48w119_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w120/USGS_13_n48w120_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w121/USGS_13_n48w121_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w122/USGS_13_n48w122_20230307.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w123/USGS_13_n48w123_20240327.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w124/USGS_13_n48w124_20240327.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n48w125/USGS_13_n48w125_20240327.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w116/USGS_13_n49w116_20241127.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w117/USGS_13_n49w117_20240918.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w118/USGS_13_n49w118_20240918.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w119/USGS_13_n49w119_20240918.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w120/USGS_13_n49w120_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w121/USGS_13_n49w121_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w122/USGS_13_n49w122_20230307.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w123/USGS_13_n49w123_20240327.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w124/USGS_13_n49w124_20240327.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n49w125/USGS_13_n49w125_20240327.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n50w117/USGS_13_n50w117_20240918.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n50w118/USGS_13_n50w118_20240918.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n50w119/USGS_13_n50w119_20240918.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n50w120/USGS_13_n50w120_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n50w121/USGS_13_n50w121_20240617.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n50w122/USGS_13_n50w122_20180202.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n50w123/USGS_13_n50w123_20180202.tif"
  "https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/TIFF/historical/n50w124/USGS_13_n50w124_20130911.tif"
)

# Download each URL
for url in "${urls[@]}"; do
  wget -P "$output_dir" "$url"
done

echo "Download complete! Files saved in $output_dir"
