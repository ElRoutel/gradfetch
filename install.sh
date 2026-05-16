#!/bin/bash

# Directorios relativos
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config/fastfetch"

echo "Instalando gradfetch en $TARGET_DIR..."

# Crear estructura base si no existe
mkdir -p "$TARGET_DIR"

# Vincular archivos y carpetas del repositorio
# No vinculamos install.sh, README.md ni .git
for item in ascii bin pngs processedASCII themes config.jsonc gradient.conf update_logos.sh; do
    src="$REPO_DIR/$item"
    dest="$TARGET_DIR/$item"
    
    # Eliminar si ya existe y es un symlink o archivo para re-vincular
    [[ -e "$dest" || -L "$dest" ]] && rm -rf "$dest"
    
    ln -s "$src" "$dest"
    echo "  - Vinculado: $item"
done

# Asegurar ejecutables
chmod +x "$REPO_DIR"/bin/*
chmod +x "$REPO_DIR"/update_logos.sh

# Añadir alias
ALIAS_LINE="alias ff='$TARGET_DIR/bin/hybrid_launcher.sh'"

# Función para añadir alias de forma segura
add_alias() {
    local shell_rc="$1"
    if [[ -f "$shell_rc" ]]; then
        if ! grep -q "alias ff=" "$shell_rc"; then
            echo "$ALIAS_LINE" >> "$shell_rc"
            echo "  - Alias 'ff' añadido a $shell_rc"
        else
            echo "  - Alias 'ff' ya existe en $shell_rc (ignorado)"
        fi
    fi
}

add_alias "$HOME/.bashrc"
add_alias "$HOME/.zshrc"

echo "Instalación completada. Reinicia tu terminal o ejecuta 'source ~/.bashrc' (o .zshrc)."
