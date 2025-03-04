#!/bin/bash
#SBATCH -N1 -n4 -t 2-0 --mail-type=END --mail-user=hthirima@fredhutch.org -A holland_e

## This example script extracts .baf files from the source.
## input = text file with subdirectory names in the source directory
## base_dir = main source directory
## dest_dir = destination directory


# Ensure the script receives the required input arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <input_file> <base_directory>"
    exit 1
fi

input="$1"
BASE_DIR="$2"
DEST_DIR="/hpc/temp/ALL_BAFS"

# Check if input file exists
if [[ ! -f "$input" ]]; then
    echo "Error: Input file '$input' not found!"
    exit 1
fi

# Process each line from the input file
while IFS= read -r line; do
    echo "Processing: $line"

    SOURCE_DIR="${BASE_DIR}/${line}"
    FILE_PATH="${SOURCE_DIR}/${line}.baf"

    # Check if source directory exists
    if [[ ! -d "$SOURCE_DIR" ]]; then
        echo "Warning: Directory '$SOURCE_DIR' does not exist. Skipping..."
        continue
    fi

    # Check if file exists before copying
    if [[ -f "$FILE_PATH" ]]; then
        cp "$FILE_PATH" "$DEST_DIR"
        echo "Copied '$FILE_PATH' to '$DEST_DIR'"
    else
        echo "Warning: File '$FILE_PATH' not found in '$SOURCE_DIR'. Skipping..."
    fi
done < "$input"

echo "Processing completed."
