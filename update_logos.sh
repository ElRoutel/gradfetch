#!/bin/bash

# Directorios relativos
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PNG_DIR="$BASE_DIR/pngs"
PROCESSED_DIR="$BASE_DIR/processedASCII"
CACHE_POOL="$HOME/.cache/fastfetch-pool"

# Limpiar pool
echo "Actualizando pool de logos en $CACHE_POOL..."
rm -rf "$CACHE_POOL"
mkdir -p "$CACHE_POOL"

# Enlazar PNGs
count_png=0
for f in "$PNG_DIR"/*.png; do
    [[ -e "$f" ]] || continue
    ln -s "$f" "$CACHE_POOL/$(basename "$f")"
    ((count_png++))
done

# Enlazar ASCIIs procesados
count_ascii=0
for f in "$PROCESSED_DIR"/*.txt; do
    [[ -e "$f" ]] || continue
    ln -s "$f" "$CACHE_POOL/$(basename "$f")"
    ((count_ascii++))
done

echo "Pool reconstruido: $count_png PNGs y $count_ascii archivos ASCII vinculados."
