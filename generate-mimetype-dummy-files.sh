#!/bin/bash

output_dir="$HOME/Desktop/mimetype-test"
mkdir -p "$output_dir"

xmlstarlet sel \
  -N x="http://www.freedesktop.org/standards/shared-mime-info" \
  -t -m '//x:mime-type' \
    -v '@type' -o ' ' \
    -m 'x:glob' -v '@pattern' -o ',' \
  -n \
  /usr/share/mime/packages/freedesktop.org.xml | while IFS= read -r line; do
    # Extract mime type and glob patterns
    mime_type=${line%% *}
    patterns=${line#* }

    # Get first glob pattern, remove trailing commas
    first_pattern=$(echo "$patterns" | sed 's/,$//' | cut -d',' -f1)

    # Extract file extension from the glob pattern (assumes *.<ext>)
    extension="${first_pattern#*.}"

    # If extension is empty or pattern doesn't contain '.', fallback to 'file'
    if [[ "$extension" == "$first_pattern" || -z "$extension" ]]; then
      extension="file"
    fi

    filename="dummy.$extension"
    filepath="$output_dir/$filename"

    # To avoid overwriting same-named files, add a counter suffix if needed
    counter=1
    base_filepath="$filepath"
    while [[ -e "$filepath" ]]; do
      filepath="${base_filepath%.*}-$counter.${extension}"
      ((counter++))
    done

    echo "Dummy file for $mime_type" > "$filepath"
    echo "Created $filepath"
done
