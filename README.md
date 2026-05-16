# gradfetch v3.0

Gestor avanzado de logotipos, gradientes y temas para `fastfetch`.

## Descripción

**gradfetch** es una suite de herramientas diseñada para elevar la estética de `fastfetch`. Automatiza la rotación de logotipos y aplica gradientes True Color (24 bits) de alta precisión al arte ASCII. 

La versión 3.0 introduce un motor de procesamiento basado en `awk` que permite gradientes multi-color en múltiples direcciones, soporte completo para temas intercambiables y un lanzador inteligente con detección de resolución.

## Características Principales

- 🌈 **Motor de Gradientes Pro:** Soporte para modos `vertical`, `horizontal` y `diagonal` con interpolación ilimitada de colores.
- 🎨 **Soporte de Temas:** Cambia instantáneamente entre diferentes configuraciones estéticas (Ayanami, SynthWave, Cyberpunk, etc.).
- 🖼️ **Lanzador Híbrido:** Selección dinámica entre imágenes PNG (protocolo Kitty) y ASCII procesado según el tamaño de la terminal.
- 🐄 **Integración Cowthink:** Modo divertido para mostrar mensajes personalizados junto a la info del sistema.
- 📐 **Ajuste Inteligente:** Recorte y alineación automática de ASCII para una presentación perfecta en la caja de información.

## Requisitos

- `fastfetch` >= 2.x
- Terminal con soporte True Color y Kitty Graphics (ej. Kitty, WezTerm, Ghostty, Foot)
- `awk`, `bash` >= 5.x
- `ncurses` (comando `tput`)

## Instalación

```bash
git clone git@github.com:ElRoutel/gradfetch.git ~/gradfetch
cd ~/gradfetch
chmod +x install.sh
./install.sh
```

El instalador creará el alias `ff` en tu `.bashrc` o `.zshrc`.

## Uso y Comandos

| Comando | Descripción |
| :--- | :--- |
| `ff` | Ejecuta fastfetch con un logo/gradiente aleatorio del tema activo. |
| `ff -themels` | Lista todos los temas instalados y muestra el activo. |
| `ff -theme <nombre>` | Cambia el tema global (ej. `ff -theme ayanami`). |
| `ff -adjust` | Ejecuta con recorte inteligente de espacios en blanco. |
| `ff --img` | Fuerza el uso de una imagen PNG (si hay espacio). |
| `ff --ascii` | Fuerza el uso de arte ASCII procesado. |
| `ff -cts "Hola!"` | Usa `cowthink` con un mensaje personalizado. |
| `ff --debug` | Muestra tiempos de carga y detalles de selección. |

## Configuración (`gradient.conf`)

Cada tema tiene su propio `gradient.conf`, pero puedes configurar el global en `~/.config/fastfetch/gradient.conf`:

```bash
# Modo de gradiente: vertical, horizontal, diagonal
GRADIENT_MODE="diagonal"

# Lista de colores en formato "R,G,B"
GRADIENT_COLORS=(
  "255,0,255"   # Magenta
  "0,255,255"   # Cian
  "255,255,0"   # Amarillo
)

# Probabilidad de PNG sobre ASCII (0-100)
IMG_CHANCE=50
```

## Estructura de Temas

Los temas se ubican en `themes/<nombre>/` y pueden contener:
- `ascii/`: Arte ASCII original.
- `pngs/`: Imágenes para protocolo Kitty.
- `gradient.conf`: Configuración específica de colores para ese tema.
- `config.jsonc`: (Opcional) Configuración personalizada de módulos de fastfetch.

## Licencia

MIT - Creado por [ElRoutel](https://github.com/ElRoutel)
