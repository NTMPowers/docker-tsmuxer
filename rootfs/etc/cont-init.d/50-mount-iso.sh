#!/bin/sh
set -eu

if [ -n "${ISO_NAME:-}" ]; then
    case "$ISO_NAME" in
        /*) ISO_PATH="$ISO_NAME" ;;
        *)  ISO_PATH="/storage/$ISO_NAME" ;;
    esac

    if [ -f "$ISO_PATH" ]; then
        mkdir -p /iso
        umount /iso 2>/dev/null || true
        echo "Mounting '$ISO_PATH' to /iso..."
        mount -t udf,iso9660 -o ro,loop "$ISO_PATH" /iso
        echo "Successfully mounted to /iso"
    else
        echo "WARNING: '$ISO_PATH' not found! Skipping mount." >&2
    fi
fi
