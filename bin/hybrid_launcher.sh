#!/bin/bash

# Directorios relativos
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PNG_DIR="$BASE_DIR/pngs"
PROCESSED_DIR="$BASE_DIR/processedASCII"
CONF="$BASE_DIR/gradient.conf"
PROCESSOR="$BASE_DIR/bin/gradient_processor.sh"

DEBUG=false
[[ "$1" == "--debug" ]] && DEBUG=true

log_debug() {
    if $DEBUG; then
        local now=$(date +%s%3N)
        local delta=$((now - start_time))
        echo "DEBUG [${delta}ms]: $1" >&2
    fi
}

start_time=$(date +%s%3N)
log_debug "Iniciando hybrid_launcher"

# Cargar configuración
if [[ -f "$CONF" ]]; then
    source "$CONF"
else
    IMG_CHANCE=50
fi

COLS=$(tput cols)
LINES=$(tput lines)
log_debug "Dimensiones detectadas: ${COLS}x${LINES}"

# Lógica de fallback por tamaño
if (( COLS < 60 )); then
    log_debug "Terminal demasiado pequeño (< 60), usando --logo none"
    fastfetch --logo none
    exit 0
elif (( COLS < 100 )); then
    log_debug "Terminal mediano (60-100), usando --logo-type auto"
    fastfetch --logo-type auto
    exit 0
fi

# Decidir PNG vs ASCII
ROLL=$(( RANDOM % 100 ))
log_debug "Roll: $ROLL / Chance: $IMG_CHANCE"

if (( ROLL < IMG_CHANCE )); then
    # Intento de modo PNG (Kitty)
    PNG_FILES=("$PNG_DIR"/*.png)
    if [[ -e "${PNG_FILES[0]}" ]]; then
        RANDOM_PNG="${PNG_FILES[RANDOM % ${#PNG_FILES[@]}]}"
        # Calcular dimensiones seguras (aprox 1/4 del ancho)
        WIDTH=$(( COLS / 4 ))
        log_debug "Usando PNG: $(basename "$RANDOM_PNG") (Width: $WIDTH)"
        fastfetch --logo "$RANDOM_PNG" --logo-type kitty --logo-width "$WIDTH"
        exit 0
    else
        log_debug "No se encontraron PNGs en $PNG_DIR, cayendo a ASCII"
    fi
fi

# Modo ASCII (Gradient)
PROCESSED_FILES=("$PROCESSED_DIR"/*.txt)
if [[ ! -e "${PROCESSED_FILES[0]}" ]]; then
    log_debug "Directorio de procesados vacío, ejecutando processor..."
    bash "$PROCESSOR"
    PROCESSED_FILES=("$PROCESSED_DIR"/*.txt)
fi

if [[ -e "${PROCESSED_FILES[0]}" ]]; then
    RANDOM_ASCII="${PROCESSED_FILES[RANDOM % ${#PROCESSED_FILES[@]}]}"
    log_debug "Usando ASCII: $(basename "$RANDOM_ASCII")"
    fastfetch --logo "$RANDOM_ASCII" --logo-type file-raw
else
    log_debug "No se encontraron archivos ASCII, usando fastfetch por defecto"
    fastfetch
fi
