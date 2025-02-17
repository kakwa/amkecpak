#!/bin/sh

# Default values
CREATE_SUM="false"
SUBMODULE="false"
MANIFEST_FILE="$(dirname "$0")/../MANIFEST"
EXPECTED_SUM=""

help() {
  cat <<EOF
Usage: $(basename "$0") -u <url> -o <outfile> \\
    [-m <manifest file>] [-c] [-C <cache dir>]

Download files, checking them against a manifest.

Arguments:
  -u <url>           URL of the file to download.
  -o <outfile>       Path to output file.
  -m <manifest file> Path to manifest file (file containing hashes).
  -c                 Flag to update the manifest file.
  -C <cache dir>     Directory for caching downloads.
  -t <tag>           Git tag to check out.
  -r <revision>      Git revision to check out.
  -s                 Initialize and update submodules.
EOF
  exit 0
}

exit_error() {
  echo "[ERROR] $1" >&2
  [ -d "$TMP_CO_DIR" ] && rm -rf -- $TMP_CO_DIR
  exit 1
}

# Parse arguments
while getopts ":hu:o:m:cC:t:r:s" opt; do
  case $opt in
    h) help ;;
    u) URL="$OPTARG" ;;
    o) OUTFILE="$OPTARG" ;;
    m) MANIFEST_FILE="$OPTARG" ;;
    c) CREATE_SUM="true" ;;
    C) CACHE_DIR="$OPTARG" ;;
    t) TAG="$OPTARG" ;;
    r) REVISION="$OPTARG" ;;
    s) SUBMODULE="true" ;;
    \?) exit_error "Invalid option: -$OPTARG" ;;
    :) exit_error "Option -$OPTARG requires an argument." ;;
  esac
done

# Validate required arguments
[ -z "$URL" ] && exit_error "Missing -u <url> argument."
[ -z "$OUTFILE" ] && exit_error "Missing -o <outfile> argument."

TMP_CO_DIR=$(mktemp -d)
mkdir -p "$TMP_CO_DIR"

SOURCE_FILE=$(basename "$OUTFILE")

checkout_repo() {
  cd ${TMP_CO_DIR}
  if [ -n "$REVISION" ]; then
    # Checkout a specific revision
    git clone "$URL" "$CO_DIR" || exit_error "Download failed."
    git checkout "$REVISION" || exit_error "Revision checkout failed."
  else
    # Checkout a tag/branch
    git clone -c advice.detachedHead=false  --depth 1 --branch "$TAG" "$URL" "$CO_DIR" || exit_error "Tag checkout failed."
  fi
  if [ "$SUBMODULE" = "true" ]
  then
      git submodule update --init --recursive || exit_error "Submodule checkout failed"
  fi
  cd -
  tar -C "$TMP_CO_DIR" -zcf "$(realpath $OUTFILE)" "$CO_DIR" || exit_error "Failed to create source archive."
}

set_checksum() {
  [ -e "$MANIFEST_FILE" ] || touch "$MANIFEST_FILE"
  if [ -z "$EXPECTED_SUM" ]; then
    echo "$SOURCE_FILE=$SUM" >> "$MANIFEST_FILE"
  else
    sed -i "s/^$SOURCE_FILE=.*/$SOURCE_FILE=$SUM/" "$MANIFEST_FILE"
  fi
}

# Process output filename
CO_DIR=$(basename "${OUTFILE}" | sed 's/\.orig\.tar\.gz$//' | sed 's/.tar\.gz$//' | sed 's/_/-/')

# Read expected checksum if manifest file exists
if [ -e "$MANIFEST_FILE" ]; then
  EXPECTED_SUM=$(sed -n "s/^$SOURCE_FILE=\(.*\)/\1/p" "$MANIFEST_FILE")
fi

ORG_DIR=$(pwd)

CACHE_FILE="${CACHE_DIR}/${SOURCE_FILE}"

# File already cached
if [ -f "$CACHE_FILE" ]; then
  # extract the content
  tar -xf "$CACHE_FILE" -C "$TMP_CO_DIR" || exit_error "Failed to extract cache."
  cp "$CACHE_FILE" "$OUTFILE" || exit_error "Failed to copy cache file."
else
  checkout_repo
  cp "$OUTFILE" "$CACHE_FILE"
fi

cd "$ORG_DIR" || exit_error "Failed to return to original directory."

# Compute checksum
SUM=$(cd "$TMP_CO_DIR/$CO_DIR" && git rev-parse HEAD)

# Update or verify manifest
if [ "$CREATE_SUM" = "true" ]
    set_checksum
then
  [ "$EXPECTED_SUM" = "$SUM" ] || exit_error "Checksum mismatch for '$URL'. Expected: '$EXPECTED_SUM', Got: '$SUM'"
fi

# Cleanup
rm -rf -- "$TMP_CO_DIR"
exit 0
