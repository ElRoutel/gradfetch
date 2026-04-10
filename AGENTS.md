# Guía de Implementación para Agentes Autónomos

Este documento contiene el plan operativo para el despliegue de gradfetch en sistemas Linux.

## Checklist de Precondiciones

- [ ] fastfetch >= 2.x disponible en $PATH
- [ ] Terminal con soporte para protocolo Kitty instalado
- [ ] Bash >= 5 instalado
- [ ] Comando `tput` disponible (paquete ncurses en Arch)

## Plan de Implementación

1. Clonar el repositorio y acceder al directorio raíz:
   `git clone git@github.com:ElRoutel/gradfetch.git ~/gradfetch && cd ~/gradfetch`

2. Ejecutar el script de instalación:
   `./install.sh`
   *Resultado esperado:* Salida por terminal indicando la creación de enlaces simbólicos en `~/.config/fastfetch` y la adición del alias `ff`.

3. Poblar directorios de recursos:
   - Añadir archivos .txt con arte ASCII en `~/gradfetch/ascii/`.
   - Añadir archivos .png compatibles con Kitty en `~/gradfetch/pngs/`.

4. Validar el procesador de gradientes:
   `bash ~/gradfetch/bin/gradient_processor.sh`
   *Resultado esperado:* Creación de archivos .txt coloreados en `~/gradfetch/processedASCII/`.

5. Probar el lanzador híbrido:
   `bash ~/gradfetch/bin/hybrid_launcher.sh --debug`
   *Resultado esperado:* Ejecución de fastfetch con el logotipo seleccionado y trazas de depuración en stderr indicando tiempos de carga.

## Variables de Configuración (gradient.conf)

Las variables siguientes deben ser números enteros entre 0 y 255:
- `COLOR_TOP_R`, `COLOR_TOP_G`, `COLOR_TOP_B`: Componentes RGB del color superior.
- `COLOR_BOTTOM_R`, `COLOR_BOTTOM_G`, `COLOR_BOTTOM_B`: Componentes RGB del color inferior.
- `IMG_CHANCE`: Entero entre 0 y 100 (probabilidad).

## Resolución de Problemas

- **Falla en modo PNG:** Verificar que el terminal soporta el protocolo Kitty mediante `fastfetch --logo-type kitty`. Si falla, comprobar la variable `$TERM`.
- **ASCII sin color:** Asegurarse de que el visor o terminal soporta colores ANSI de 24 bits (True Color).
- **Fallback a auto/none:** Si se dispara el fallback inesperadamente, verificar el ancho del terminal con `tput cols`. Valores menores a 60 activan el modo `none`, y menores a 100 activan `auto`.
- **Error de permisos:** Confirmar que todos los archivos en `~/gradfetch/bin/` y el archivo `install.sh` tienen permisos de ejecución (`chmod +x`).
