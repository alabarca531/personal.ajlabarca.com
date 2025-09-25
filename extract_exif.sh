#!/bin/bash

# Script to extract EXIF data from images and generate Hugo front matter
# Usage: ./extract_exif.sh <image_file>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <image_file>"
    exit 1
fi

IMAGE_FILE="$1"
BASENAME=$(basename "$IMAGE_FILE" | sed 's/\.[^.]*$//')

if ! command -v exiftool &> /dev/null; then
    echo "exiftool not found. Install with: brew install exiftool"
    exit 1
fi

echo "Extracting EXIF data for: $IMAGE_FILE"
echo "----------------------------------------"

# Extract key metadata
CAMERA=$(exiftool -Make -Model -s3 "$IMAGE_FILE" | tr '\n' ' ' | sed 's/  / /g' | sed 's/^ *//;s/ *$//')
LENS=$(exiftool -LensModel -s3 "$IMAGE_FILE" 2>/dev/null || echo "")
FOCAL_LENGTH=$(exiftool -FocalLength -s3 "$IMAGE_FILE" 2>/dev/null | sed 's/ mm/mm/')
APERTURE=$(exiftool -FNumber -s3 "$IMAGE_FILE" 2>/dev/null)
SHUTTER=$(exiftool -ExposureTime -s3 "$IMAGE_FILE" 2>/dev/null)
ISO=$(exiftool -ISO -s3 "$IMAGE_FILE" 2>/dev/null)
DATE_TAKEN=$(exiftool -DateTimeOriginal -s3 "$IMAGE_FILE" 2>/dev/null)
GPS_LAT=$(exiftool -GPSLatitude -s3 "$IMAGE_FILE" 2>/dev/null)
GPS_LON=$(exiftool -GPSLongitude -s3 "$IMAGE_FILE" 2>/dev/null)

# Build settings string
SETTINGS=""
if [ ! -z "$FOCAL_LENGTH" ]; then
    SETTINGS="$FOCAL_LENGTH"
fi
if [ ! -z "$APERTURE" ]; then
    SETTINGS="$SETTINGS · f/$APERTURE"
fi
if [ ! -z "$SHUTTER" ]; then
    if [[ $SHUTTER == *"/"* ]]; then
        SETTINGS="$SETTINGS · ${SHUTTER}s"
    else
        SETTINGS="$SETTINGS · 1/${SHUTTER}s"
    fi
fi
if [ ! -z "$ISO" ]; then
    SETTINGS="$SETTINGS · ISO $ISO"
fi

# Clean up settings string
SETTINGS=$(echo "$SETTINGS" | sed 's/^ · //')

echo "Hugo front matter format:"
echo "  - src: \"$IMAGE_FILE\""
echo "    title: \"$BASENAME\""
echo "    params:"
if [ ! -z "$CAMERA" ]; then
    echo "      camera: \"$CAMERA\""
fi
if [ ! -z "$SETTINGS" ]; then
    echo "      settings: \"$SETTINGS\""
fi
if [ ! -z "$DATE_TAKEN" ]; then
    echo "      date: \"$DATE_TAKEN\""
fi
if [ ! -z "$GPS_LAT" ] && [ ! -z "$GPS_LON" ]; then
    echo "      location: \"$GPS_LAT, $GPS_LON\""
fi
echo "      description: \"Add description here\""

echo ""
echo "Raw EXIF data:"
echo "Camera: $CAMERA"
echo "Lens: $LENS"
echo "Settings: $SETTINGS"
echo "Date: $DATE_TAKEN"
if [ ! -z "$GPS_LAT" ]; then
    echo "GPS: $GPS_LAT, $GPS_LON"
fi