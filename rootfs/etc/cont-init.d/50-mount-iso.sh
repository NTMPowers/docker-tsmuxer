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

        # Inject file:///iso specifically into the shortcuts= line
        CONF="/config/xdg/config/QtProject.conf"
        mkdir -p "$(dirname "$CONF")"
        if [ -f "$CONF" ]; then
            if grep -q '^shortcuts=' "$CONF"; then
                if ! grep -E -q '^shortcuts=.*file:///iso' "$CONF"; then
                    sed -i 's|^shortcuts=.*|&, file:///iso|' "$CONF"
                fi
            else
                printf "\n[FileDialog]\nshortcuts=file:, file:///storage, file:///iso\n" >> "$CONF"
            fi
        else
            printf "[FileDialog]\nshortcuts=file:, file:///storage, file:///iso\n" > "$CONF"
        fi
    else
        echo "WARNING: '$ISO_PATH' not found! Skipping mount." >&2
    fi
fi
