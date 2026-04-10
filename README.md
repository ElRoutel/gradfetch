# gradfetch

Gestor de logotipos y gradientes para fastfetch.

## Descripción

gradfetch automatiza la rotación y el renderizado de logotipos para fastfetch. El sistema implementa un procesador que aplica gradientes verticales RGB de 24 bits (True Color) a archivos de arte ASCII mediante códigos de escape ANSI (\e[38;2;R;G;Bm). Además, integra un lanzador híbrido que selecciona dinámicamente entre formatos PNG (vía protocolo Kitty) y ASCII procesado, basándose en la resolución del terminal y factores de probabilidad configurables.

## Requisitos

- fastfetch >= 2.x
- Terminal con soporte para protocolo Kitty (ej. Kitty, WezTerm)
- Bash >= 5.x
- ncurses (comando tput disponible)

## Instalación

Para instalar gradfetch en el entorno del usuario:

```bash
git clone git@github.com:ElRoutel/gradfetch.git ~/gradfetch
cd ~/gradfetch
./install.sh
```

El script de instalación creará enlaces simbólicos en `~/.config/fastfetch` y añadirá el alias `ff` a los archivos de configuración de la shell detectados (.bashrc, .zshrc).

## Configuración

La configuración se gestiona en el archivo `gradient.conf`. Las variables disponibles son:

| Campo | Tipo | Rango | Descripción |
| :--- | :--- | :--- | :--- |
| COLOR_TOP_R | Entero | 0–255 | Componente roja del color superior. |
| COLOR_TOP_G | Entero | 0–255 | Componente verde del color superior. |
| COLOR_TOP_B | Entero | 0–255 | Componente azul del color superior. |
| COLOR_BOTTOM_R | Entero | 0–255 | Componente roja del color inferior. |
| COLOR_BOTTOM_G | Entero | 0–255 | Componente verde del color inferior. |
| COLOR_BOTTOM_B | Entero | 0–255 | Componente azul del color inferior. |
| IMG_CHANCE | Entero | 0–100 | Probabilidad de mostrar PNG sobre ASCII. |

## Uso

Ejecutar el alias creado:

```bash
ff
```

Para depurar la selección de logotipos y tiempos de ejecución:

```bash
ff --debug
```

## Estructura de archivos

- `ascii/`: Almacén de archivos .txt originales.
- `bin/`: Scripts ejecutables del sistema.
- `pngs/`: Logotipos en formato PNG.
- `processedASCII/`: Salida generada con códigos de color ANSI.
- `gradient.conf`: Archivo de configuración de colores y comportamiento.
- `update_logos.sh`: Sincronizador de enlaces simbólicos en caché.

## Licencia

MIT
