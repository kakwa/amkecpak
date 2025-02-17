#!/bin/sh

# Constants
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
DEFAULT_MANIFEST_FILE="${SCRIPT_DIR}/../MANIFEST"

# Configuration variables
url=""
outfile=""
manifest_file="$DEFAULT_MANIFEST_FILE"
create_sum="false"
cache_dir=""
tag=""
revision=""
use_submodules="false"
tmp_dir=""

cleanup() {
    tmp_directory="$1"
    if [ -d "$tmp_directory" ]; then
        rm -rf -- "$tmp_directory"
    fi
}

error_exit() {
    error_message="$1"
    tmp_directory="$2"
    echo "[ERROR] $error_message" >&2
    cleanup "$tmp_directory"
    exit 1
}

help() {
    cat <<EOF
Usage: $(basename "$0") -u <url> -o <outfile> [OPTIONS]

Download files and verify them against a manifest.

Required Arguments:
    -u <url>           URL of the Git repository to download
    -o <outfile>       Path to output tarball

Optional Arguments:
    -m <manifest>      Path to manifest file (default: $DEFAULT_MANIFEST_FILE)
    -c                 Update the manifest file with new checksum
    -C <cache-dir>     Directory for caching downloads
    -t <tag>          Git tag to check out
    -r <revision>     Git revision to check out
    -s                Initialize and update submodules
    -h                Show this help message
EOF
    exit 0
}

read_expected_checksum() {
    manifest_path="$1"
    source_name="$2"
    [ -f "$manifest_path" ] || return
    sed -n "s/^$source_name=\\(.*\\)/\\1/p" "$manifest_path"
}

checkout_repository() {
    checkout_url="$1"
    checkout_dir="$2"
    checkout_tag="$3"
    checkout_revision="$4"
    checkout_submodules="$5"
    tmp_directory="$6"

    if [ -n "$checkout_revision" ]; then
        git clone "$checkout_url" "$checkout_dir" || error_exit "Repository clone failed" "$tmp_directory"
        (cd "$checkout_dir" && git -c advice.detachedHead=false checkout "$checkout_revision") || error_exit "Revision checkout failed" "$tmp_directory"
    else
        git clone -c advice.detachedHead=false --depth 1 --branch "$checkout_tag" \
            "$checkout_url" "$checkout_dir" || error_exit "Tag checkout failed" "$tmp_directory"
    fi

    if [ "$checkout_submodules" = "true" ]; then
        (cd "$checkout_dir" && git submodule update --init --recursive) || \
            error_exit "Submodule initialization failed" "$tmp_directory"
    fi
}

create_tarball() {
    source_dir="$1"
    target_file="$2"
    tmp_directory="$3"

    tar -C "$(dirname "$source_dir")" -zcf "$target_file" \
        "$(basename "$source_dir")" || error_exit "Tarball creation failed" "$tmp_directory"
}

update_manifest() {
    manifest_path="$1"
    source_name="$2"
    new_checksum="$3"
    old_checksum="$4"

    [ -f "$manifest_path" ] || touch "$manifest_path"

    if [ -z "$old_checksum" ]; then
        echo "$source_name=$new_checksum" >> "$manifest_path"
    else
        sed -i "s/^${source_name}=.*/$source_name=$new_checksum/" "$manifest_path"
    fi
}

verify_checksum() {
    actual_sum="$1"
    expected="$2"
    create_flag="$3"
    manifest_path="$4"
    source_name="$5"
    repository_url="$6"
    tmp_directory="$7"

    if [ "$create_flag" = "true" ]; then
        update_manifest "$manifest_path" "$source_name" "$actual_sum" "$expected"
        return
    fi
    if [ "$expected" != "$actual_sum" ]; then
        error_exit "Checksum mismatch for '$repository_url'. Manifest: '$expected', File: '$actual_sum'" "$tmp_directory"
    fi
}

while getopts ":hu:o:m:cC:t:r:s" opt; do
    case $opt in
        h) help ;;
        u) url="$OPTARG" ;;
        o) outfile="$OPTARG" ;;
        m) manifest_file="$OPTARG" ;;
        c) create_sum="true" ;;
        C) cache_dir="$OPTARG" ;;
        t) tag="$OPTARG" ;;
        r) revision="$OPTARG" ;;
        s) use_submodules="true" ;;
        \?) error_exit "Invalid option: -$OPTARG" "$tmp_dir" ;;
        :) error_exit "Option -$OPTARG requires an argument" "$tmp_dir" ;;
    esac
done

# Validate required arguments
[ -z "$url" ] && error_exit "Missing required argument: -u <url>" "$tmp_dir"
[ -z "$outfile" ] && error_exit "Missing required argument: -o <outfile>" "$tmp_dir"

source_file="$(basename "$outfile")"
# Convert filename to directory name, replacing underscores with hyphens
# and removing .tar.gz and .orig.tar.gz suffixes
source_dir_name="$(echo "$source_file" | sed -e 's/\.orig\.tar\.gz$//' \
                                  -e 's/\.tar\.gz$//' \
                                  -e 's/_/-/')"

expected_checksum=$(read_expected_checksum "$manifest_file" "$source_file")

# Create temporary directory
tmp_dir="$(mktemp -d)"
trap 'cleanup "$tmp_dir"' EXIT
co_dir="${tmp_dir}/${source_dir_name}"

if [ -n "$cache_dir" ] && [ -f "${cache_dir}/${source_file}" ]; then
    # Use cached file if available
    tar -xf "${cache_dir}/${source_file}" -C "$tmp_dir" || \
        error_exit "Cache extraction failed" "$tmp_dir"
    cp "${cache_dir}/${source_file}" "$outfile" || \
        error_exit "Cache file copy failed" "$tmp_dir"
else
    # Download and package fresh
    checkout_repository "$url" "$co_dir" "$tag" "$revision" "$use_submodules" "$tmp_dir"
    create_tarball "$co_dir" "$outfile" "$tmp_dir"
    # Update cache if enabled
    if [ -n "$cache_dir" ]; then
        mkdir -p "$cache_dir"
        cp "$outfile" "${cache_dir}/${source_file}"
    fi
fi

# Compute and verify checksum
checksum="$(cd "$co_dir" && git rev-parse HEAD)"
verify_checksum "$checksum" "$expected_checksum" "$create_sum" "$manifest_file" "$source_file" "$url" "$tmp_dir"
