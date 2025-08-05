#!/bin/bash

if ! command -v inkscape &> /dev/null; then
    echo "Inkscape is required but not installed. Please install it and try again."
    exit 1
fi

# Check correct input
if [ -z "$1" ]; then
    echo "Usage: $0 icon.svg"
    exit 1
fi

INPUT_SVG="$1"
BASENAME=$(basename "$INPUT_SVG" .svg)

# Output sizes
SIZES=(48 32 24 22 16)

# output in same dir
OUTPUT_BASE="./${BASENAME}_icons"

# Create PNGs in subfolders by size
for SIZE in "${SIZES[@]}"; do
    OUTPUT_DIR="${OUTPUT_BASE}/${SIZE}"
    mkdir -p "$OUTPUT_DIR"
    OUTPUT_FILE="${OUTPUT_DIR}/${BASENAME}.png"

    echo "Generating ${OUTPUT_FILE}..."
    inkscape "$INPUT_SVG" --export-type=png --export-filename="$OUTPUT_FILE" -w "$SIZE" -h "$SIZE"
done

echo "Icons generated."
