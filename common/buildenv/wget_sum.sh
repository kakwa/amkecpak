#!/bin/sh

# Print help message
help() {
  cat <<EOF
usage: $(basename "$0") -u <url> -o <outfile> \\
    [-m <manifest file>] [-c] [-C <cache dir>]
Download files, checking them against a manifest

arguments:
  -u <url>: url of the file to download
  -o <outfile>: path to output file
  -m <manifest file>: path to manifest file (file containing hashes)
  -c: flag to fill the manifest file
  -C <cache dir>: directory where to cache downloads
EOF
  exit 1
}

# Handle error and clean up
exit_error() {
    message="$1"
    outfile="$2"
    cache_dir="$3"
    source_file="$4"

    echo "$message" >&2
    cleanup "$outfile" "$cache_dir" "$source_file"
    exit 1
}

# Clean up temporary files
cleanup() {
    outfile="$1"
    cache_dir="$2"
    source_file="$3"

    [ -n "$outfile" ] && [ -f "$outfile" ] && rm -f "$outfile"
    [ -n "$cache_dir" ] && [ -n "$source_file" ] && [ -f "${cache_dir}/${source_file}" ] && rm -f "${cache_dir}/${source_file}"
}

# Create directory if it doesn't exist
ensure_directory() {
    dir="$1"
    outfile="$2"
    cache_dir="$3"
    source_file="$4"

    [ -d "$dir" ] || mkdir -p "$dir" || exit_error "[ERROR] Failed to create directory: $dir" "$outfile" "$cache_dir" "$source_file"
}

# Get expected checksum from manifest file
get_expected_checksum() {
    manifest_file="$1"
    source_file="$2"

    if [ -e "$manifest_file" ]; then
        grep "^$source_file=" "$manifest_file" | sed "s/$source_file=\\(.*\\)/\\1/"
    fi
}

# Download the file
download_file() {
    url="$1"
    outfile="$2"
    cache_dir="$3"
    source_file="$4"

    if [ -n "$cache_dir" ]; then
        if [ ! -f "${cache_dir}/${source_file}" ]; then
            wget -q --show-progress "$url" -O "${cache_dir}/${source_file}" ||
                exit_error "[ERROR] download failed" "$outfile" "$cache_dir" "$source_file"
        fi
        cp "${cache_dir}/${source_file}" "$outfile" ||
            exit_error "[ERROR] Failed to copy from cache" "$outfile" "$cache_dir" "$source_file"
    else
        wget -q --show-progress "$url" -O "$outfile" ||
            exit_error "[ERROR] download failed" "$outfile" "$cache_dir" "$source_file"
    fi
}

# Calculate checksum of a file
calculate_checksum() {
    file="$1"
    outfile="$2"
    cache_dir="$3"
    source_file="$4"

    sum=$(sha512sum "$file" | awk '{print $1}')
    [ -z "$sum" ] && exit_error "[ERROR] Failed to calculate checksum" "$outfile" "$cache_dir" "$source_file"
    echo "$sum"
}

# Create or update manifest file with new checksum
update_manifest() {
    manifest_file="$1"
    source_file="$2"
    sum="$3"
    expected_sum="$4"
    outfile="$5"
    cache_dir="$6"

    if [ ! -e "$manifest_file" ]; then
        touch "$manifest_file" ||
            exit_error "[ERROR] Failed to create manifest file" "$outfile" "$cache_dir" "$source_file"
    fi

    if [ -z "$expected_sum" ]; then
        echo "$source_file=$sum" >> "$manifest_file" ||
            exit_error "[ERROR] Failed to update manifest file" "$outfile" "$cache_dir" "$source_file"
    else
        # Use a temporary file to avoid issues with in-place editing
        sed "s/^$source_file=.*/$source_file=$sum/" "$manifest_file" > "$manifest_file.tmp" &&
        mv "$manifest_file.tmp" "$manifest_file" ||
            exit_error "[ERROR] Failed to update manifest file" "$outfile" "$cache_dir" "$source_file"
    fi
    echo "[INFO] Checksum added to manifest file: $manifest_file"
}

# Verify the checksum against expected value
verify_checksum() {
    sum="$1"
    expected_sum="$2"
    url="$3"
    source_file="$4"
    outfile="$5"
    cache_dir="$6"

    if [ -z "$expected_sum" ]; then
        echo "[WARNING] No checksum found in manifest for $source_file"
    elif [ "$expected_sum" != "$sum" ]; then
        exit_error "[ERROR] Bad checksum for '$url'\nexpected: $expected_sum\ngot:     $sum" "$outfile" "$cache_dir" "$source_file"
    else
        echo "[INFO] Checksum verification successful"
    fi
}

# Set up trap for clean exit on interrupts
trap 'exit_error "[ERROR] Download interrupted" "$OUTFILE" "$CACHE_DIR" "$SOURCE_FILE"' INT TERM

# Default values
CREATE_SUM=1
MANIFEST_FILE="$(dirname "$0")/../MANIFEST"

# Parse command line arguments
while getopts ":hu:o:m:cC:" opt; do
  case $opt in
    h) help;;
    u) URL="$OPTARG";;
    o) OUTFILE="$OPTARG";;
    m) MANIFEST_FILE="$OPTARG";;
    c) CREATE_SUM=0;;
    C) CACHE_DIR="$OPTARG";;
    \?) echo "Invalid option: -$OPTARG" >&2; help;;
    :)  echo "Option -$OPTARG requires an argument." >&2;help;;
  esac
done

# Validate required arguments
[ -z "$URL" ] && exit_error "[ERROR] missing -u <url> arg" "$OUTFILE" "$CACHE_DIR" "$SOURCE_FILE"
[ -z "$OUTFILE" ] && exit_error "[ERROR] missing -o <out> arg" "$OUTFILE" "$CACHE_DIR" "$SOURCE_FILE"

# Extract the filename from the output path
SOURCE_FILE="$(basename "${OUTFILE}")"

# Create directories if they don't exist
ensure_directory "$(dirname "$OUTFILE")" "$OUTFILE" "$CACHE_DIR" "$SOURCE_FILE"
[ -n "$CACHE_DIR" ] && ensure_directory "$CACHE_DIR" "$OUTFILE" "$CACHE_DIR" "$SOURCE_FILE"

# Get expected checksum
EXPECTED_SUM=$(get_expected_checksum "$MANIFEST_FILE" "$SOURCE_FILE")

# Download the file
download_file "$URL" "$OUTFILE" "$CACHE_DIR" "$SOURCE_FILE"

# Calculate checksum
SUM=$(calculate_checksum "$OUTFILE" "$OUTFILE" "$CACHE_DIR" "$SOURCE_FILE")

# Update or verify the checksum
if [ $CREATE_SUM -eq 0 ]; then
    update_manifest "$MANIFEST_FILE" "$SOURCE_FILE" "$SUM" "$EXPECTED_SUM" "$OUTFILE" "$CACHE_DIR"
else
    verify_checksum "$SUM" "$EXPECTED_SUM" "$URL" "$SOURCE_FILE" "$OUTFILE" "$CACHE_DIR"
fi

echo "[SUCCESS] Download completed: $OUTFILE"
exit 0
