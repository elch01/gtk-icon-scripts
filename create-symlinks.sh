#!/bin/bash

# Prompt user for the path to the existing SVG file
read -rp "Enter the full path to the existing SVG file (e.g., /path/to/apps/96/icon.svg): " source_svg

# Validate SVG
if [[ ! -f "$source_svg" ]] || [[ "${source_svg##*.}" != "svg" ]]; then
    echo "Error: File does not exist or is not an SVG."
    exit 1
fi

# Extract details
svg_dir=$(dirname "$source_svg")
svg_filename=$(basename "$source_svg")

# Ensure it's in a 96/ folder
if [[ "$(basename "$svg_dir")" != "96" ]]; then
    echo "Error: SVG must be in a '96' folder."
    exit 1
fi

# Get parent directory (apps/ or similar)
parent_dir=$(dirname "$svg_dir")

# Prompt for symlink name
read -rp "Enter the symlink name (e.g., com.example.App): " symlink_name

# Symlink in 96/ directory
cd "$svg_dir" || exit 1
ln -sn "$svg_filename" "$symlink_name.svg"
echo "Created relative symlink: $svg_dir/$symlink_name.svg -> $svg_filename"

# Symlink PNGs in 16,22,24,32,48
sizes=(16 22 24 32 48)

for size in "${sizes[@]}"; do
    png_dir="$parent_dir/$size"
    source_png="$png_dir/${svg_filename%.svg}.png"
    symlink_png="$png_dir/$symlink_name.png"

    if [[ ! -f "$source_png" ]]; then
        echo "Warning: $source_png does not exist, skipping."
        continue
    fi

    cd "$png_dir" || continue

    # Calculate truly relative path to the target PNG
    target_png_basename=$(basename "$source_png")
    ln -sn "$target_png_basename" "$symlink_name.png"
    echo "Created relative symlink: $png_dir/$symlink_name.png -> $target_png_basename"
done

echo "Done. All symlinks are relative."
