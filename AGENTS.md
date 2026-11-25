# Guía de Implementación para Agentes Autónomos

Este documento contiene el plan operativo para desplegar y mantener gradfetch en sistemas Linux.

## Checklist de Precondiciones

- [ ] fastfetch >= 2.x disponible en $PATH (`kitty-icat` requiere una versión reciente)
- [ ] Terminal con soporte True Color y protocolo Kitty (Kitty, WezTerm, Foot)
- [ ] `kitten` en $PATH (viene con Kitty) para GIFs animados
- [ ] Bash >= 5, `awk`, `find`, `shuf`
- [ ] Comando `tput` disponible (paquete ncurses en Arch)
- [ ] Opcional: `cowthink` (paquete cowsay) para el modo `-cts`

## Plan de Implementación

1. Clonar el repositorio y acceder al directorio raíz:
   `git clone git@github.com:ElRoutel/gradfetch.git ~/gradfetch && cd ~/gradfetch`

2. Ejecutar el script de instalación:
   `./install.sh`
   *Resultado esperado:*
   - Si `~/.config/fastfetch` ya tenía contenido propio, se respalda completo en `~/fastfetch-backup-<fecha>`.
   - Se crean enlaces simbólicos en `~/.config/fastfetch` hacia el repo (`ascii`, `bin`, `pngs`, `processedASCII`, `themes`, `gradient.conf`, `update_logos.sh`).
   - Si ya existía un `config.jsonc` propio (archivo real, no enlace), se conserva sin reemplazarlo.
   - Se añade el alias `ff` a `.bashrc`/`.zshrc` si no existe.

3. Poblar directorios de recursos (global en la raíz o por tema en `themes/<nombre>/`):
   - `ascii/`: archivos `.txt` con arte ASCII sin color.
   - `pngs/`: imágenes `.png`, `.jpg`, `.jpeg`, `.webp` o `.gif`. Los GIF se muestran animados con `--logo-type kitty-icat`; el resto con `--logo-type kitty`.

4. Generar los gradientes:
   `ff -gr` (todos los temas) o `bash ~/gradfetch/bin/gradient_processor.sh` (solo global).
   *Resultado esperado:* Archivos `.txt` coloreados en `processedASCII/`. El lanzador también los regenera solo si el número de archivos en `ascii/` y `processedASCII/` no coincide.

5. Probar el lanzador híbrido:
   `ff --debug` (o `ff --img --debug` / `ff --ascii --debug`)
   *Resultado esperado:* fastfetch con el logo elegido y trazas en stderr con tiempos, tipo de logo y archivo seleccionado.

## Comandos del Lanzador (`bin/hybrid_launcher.sh`)

| Comando | Efecto |
| :--- | :--- |
| `ff` | Aleatorio entre imagen y ASCII del tema activo |
| `ff -themels` | Lista temas y muestra el activo |
| `ff -theme <nombre>` | Cambia el tema (se guarda en `~/.config/fastfetch/current_theme`) y regenera sus gradientes |
| `ff -theme default` | Vuelve a los recursos de la raíz |
| `ff --img` / `ff --ascii` (`-ct`) | Fuerza imagen o ASCII |
| `ff -cts "texto"` | Usa `cowthink` como logo |
| `ff -adjust` | Recorta sangría del ASCII y cierra las cajas de la info |
| `ff -gr` | Regenera gradientes globales y de todos los temas |
| `ff -t <ruta\|texto>` | Muestra un ASCII sin procesar (modo test) |
| `ff --debug` | Trazas de tiempos en stderr |

## Estructura de un Tema (`themes/<nombre>/`)

- `gradient.conf` (obligatorio): colores del gradiente.
- `config.jsonc` (opcional): módulos de fastfetch del tema; si falta, se usa el `config.jsonc` global.
- `ascii/`, `processedASCII/`, `pngs/` (opcionales): recursos propios del tema.

## Variables de Configuración (`gradient.conf`)

- `GRADIENT_MODE`: `vertical` (por defecto), `horizontal` o `diagonal`.
- `GRADIENT_COLORS`: array de 2 o más colores en formato `"R,G,B"` (enteros 0-255), interpolados en orden.

```bash
GRADIENT_MODE="diagonal"
GRADIENT_COLORS=(
  "100,170,255"
  "255,40,40"
)
```

Si falta `gradient.conf`, se usa blanco sólido.

## Umbrales del Lanzador (constantes en `bin/hybrid_launcher.sh`)

- `IMG_CHANCE=50`: probabilidad (0-100) de intentar imagen antes que ASCII.
- `MIN_COLS_IMG=110`, `MIN_LINES_IMG=26`: tamaño mínimo para imágenes.
- `MIN_COLS_ASCII=85`, `MIN_LINES_ASCII=22`: tamaño mínimo para ASCII.
- `MIN_COLS_TINY=60`: por debajo, fastfetch se ejecuta sin logo.

## Archivos que NO se versionan

- `current_theme`: estado local del tema activo (vive en `~/.config/fastfetch`, fuera del repo).
- `.gradient.conf.bak`: copia que genera el procesador.
- `processedASCII/*.txt` de la raíz: se regeneran solos.

## Resolución de Problemas

- **No sale la imagen:** verificar `$TERM` (debe contener `kitty` o `foot`, o `TERM_PROGRAM=WezTerm`) y que la terminal mida al menos 110x26 (`tput cols`, `tput lines`).
- **El GIF no se anima:** comprobar que `kitten` está en $PATH; sin él se usa `kitty`, que muestra un solo frame.
- **ASCII sin color:** asegurarse de que la terminal soporta colores ANSI de 24 bits (True Color).
- **Caracteres rotos en el gradiente:** el procesador usa `LC_ALL=C.utf8`; verificar que ese locale existe (`locale -a`).
- **Sin logo:** con menos de 60 columnas el lanzador desactiva el logo; si fallan imagen y ASCII, usa el logo integrado de fastfetch.
- **Error de permisos:** confirmar que `bin/*`, `install.sh` y `update_logos.sh` tienen permisos de ejecución (`chmod +x`).
