#!/bin/bash

# Directorios relativos
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASCII_DIR="$BASE_DIR/ascii"
PROCESSED_DIR="$BASE_DIR/processedASCII"
CONF="$BASE_DIR/gradient.conf"
BAK_CONF="$BASE_DIR/.gradient.conf.bak"

# Crear directorio de salida si no existe
mkdir -p "$PROCESSED_DIR"

# Cargar configuración
if [[ -f "$CONF" ]]; then
    source "$CONF"
else
    echo "Error: $CONF no encontrado" >&2
    exit 1
fi

# Verificar si la configuración cambió
if [[ -f "$BAK_CONF" ]] && cmp -s "$CONF" "$BAK_CONF"; then
    # Solo procesar si hay archivos nuevos en ascii/ que no estén en processed/
    PROCESAR_TODO=false
else
    PROCESAR_TODO=true
    cp "$CONF" "$BAK_CONF"
fi

for f in "$ASCII_DIR"/*.txt; do
    [[ -e "$f" ]] || continue
    
    filename=$(basename "$f")
    output="$PROCESSED_DIR/$filename"
    
    if [[ "$PROCESAR_TODO" = false ]] && [[ -f "$output" ]] && [[ "$f" -ot "$output" ]]; then
        continue
    fi
    
    # Leer líneas y contar
    mapfile -t lines < "$f"
    num_lines=${#lines[@]}
    
    if (( num_lines == 0 )); then
        > "$output"
        continue
    fi
    
    # Abrir archivo de salida
    : > "$output"
    
    for i in "${!lines[@]}"; do
        if (( num_lines == 1 )); then
            r=$COLOR_TOP_R
            g=$COLOR_TOP_G
            b=$COLOR_TOP_B
        else
            # Interpolación lineal
            # factor = i / (num_lines - 1)
            # valor = start + factor * (end - start)
            
            # Usar aritmética entera escalada para precisión básica en bash
            factor_scale=1000
            factor=$(( i * factor_scale / (num_lines - 1) ))
            
            r=$(( COLOR_TOP_R + (COLOR_BOTTOM_R - COLOR_TOP_R) * factor / factor_scale ))
            g=$(( COLOR_TOP_G + (COLOR_BOTTOM_G - COLOR_TOP_G) * factor / factor_scale ))
            b=$(( COLOR_TOP_B + (COLOR_BOTTOM_B - COLOR_TOP_B) * factor / factor_scale ))
        fi
        
        # Escribir línea con ANSI escape code
        printf "\e[38;2;%d;%d;%dm%s\e[0m\n" "$r" "$g" "$b" "${lines[$i]}" >> "$output"
    done
done
