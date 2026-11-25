#!/bin/bash

# --- CONFIGURACIÓN ---
# Rutas relativas a donde vive este script (funciona en el repo y en ~/.config/fastfetch)
BASE_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
DIR_ASCII="$BASE_DIR/processedASCII"
DIR_PNG="$BASE_DIR/pngs"
DIR_POOL="$HOME/.cache/fastfetch-pool"

# Colores para el output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==> Actualizando pool de logos para Fastfetch...${NC}"

# 1. Crear el directorio pool si no existe
if [ ! -d "$DIR_POOL" ]; then
    mkdir -p "$DIR_POOL"
    echo "Carpeta pool creada."
fi

# 2. Limpiar el pool actual (para evitar enlaces rotos o archivos viejos)
rm -f "$DIR_POOL"/*
echo "Pool limpiado."

# 3. Crear enlaces simbólicos para imágenes (PNG, GIF, JPG, WEBP)
count_img=0
if [ -d "$DIR_PNG" ]; then
    while IFS= read -r -d '' f; do
        ln -sf "$f" "$DIR_POOL/"
        ((count_img++))
    done < <(find "$DIR_PNG" -type f \( -iname "*.png" -o -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0)
fi

# 4. Crear enlaces simbólicos para ASCII (TXT)
count_ascii=0
if [ -d "$DIR_ASCII" ]; then
    while IFS= read -r -d '' f; do
        ln -sf "$f" "$DIR_POOL/"
        ((count_ascii++))
    done < <(find "$DIR_ASCII" -type f -iname "*.txt" -print0)
fi

# 5. Resumen
total=$(find "$DIR_POOL" -mindepth 1 -maxdepth 1 | wc -l)
echo -e "${GREEN}✔ Listo.${NC}"
echo -e "  - Imágenes enlazadas: $count_img (desde $DIR_PNG)"
echo -e "  - ASCIIs enlazados:   $count_ascii (desde $DIR_ASCII)"
echo -e "  - Total en rotación:  $total archivos."
