# Referencia Completa de Kitty y Lazygit

Guía de consulta continua para tu terminal (kitty) y tu interfaz visual de git (lazygit).

---

# PARTE 1: KITTY

## 1. Conceptos base

Kitty es tu emulador de terminal — la "ventana" donde corren tus programas de línea de comandos (bash/zsh, nvim, git, etc). No tiene relación directa con GitHub, git, o Neovim; es simplemente el contenedor visual.

Tu configuración vive en:
```
~/.config/kitty/kitty.conf
```

## 2. Recargar configuración sin reiniciar

```
Cmd+Shift+,
```
Aplica los cambios que hiciste en `kitty.conf` sin cerrar la terminal.

## 3. Opciones esenciales de configuración

```conf
# Fuente
font_family      JetBrainsMono Nerd Font
font_size        14.0

# Tema (ver sección de temas más abajo)
include current-theme.conf

# Ventana
window_padding_width 8
background_opacity 0.95
confirm_os_window_close 0

# Historial
scrollback_lines 10000
shell_integration enabled
```

## 4. Cambiar de tema

```bash
kitty +kitten themes
```
Abre un selector interactivo — navegas con flechas, presionas Enter para aplicar. Kitty guarda automáticamente el tema elegido en `current-theme.conf` y agrega el `include` correspondiente a tu `kitty.conf`.

⚠️ Si ya tienes `include current-theme.conf` escrito manualmente en tu config Y corres el kitten de temas, puede duplicarse la línea — revisa que solo aparezca una vez.

## 5. Splits (dividir la ventana en paneles)

Kitty soporta splits nativos, sin necesitar tmux:

```conf
map cmd+d launch --location=vsplit --cwd=current
map cmd+shift+d launch --location=hsplit --cwd=current
```
- `vsplit` = división vertical (paneles lado a lado)
- `hsplit` = división horizontal (paneles arriba/abajo)
- `--cwd=current` = el nuevo panel abre en la misma carpeta donde ya estabas

## 6. Navegar entre splits

```conf
map cmd+j neighboring_window down
map cmd+k neighboring_window up
map cmd+h neighboring_window left
map cmd+l neighboring_window right
```

## 7. Cerrar un panel/ventana

```conf
map cmd+w close_window
```

## 8. Tabs

```conf
map cmd+t new_tab
map cmd+shift+] next_tab
map cmd+shift+[ previous_tab
map cmd+1 goto_tab 1
map cmd+2 goto_tab 2
```

## 9. Copiar y pegar

```conf
map cmd+c copy_to_clipboard
map cmd+v paste_from_clipboard
```

## 10. kitty vs tmux — cuándo usar cada uno

| Situación | Herramienta recomendada |
|---|---|
| Trabajo local en tu Mac/Linux | kitty solo (splits/tabs nativos son suficientes) |
| Sesiones persistentes en un servidor remoto por SSH | tmux (para no perder la sesión si se corta la conexión) |
| Conectarte desde múltiples dispositivos a la misma sesión | tmux |

Para tu uso actual (desarrollo local), probablemente no necesitas tmux.

## 11. Comandos de diagnóstico

```bash
kitty --debug-config     → revisa errores de sintaxis en tu config antes de aplicarla
```

---

# PARTE 2: LAZYGIT

## 1. Qué es y por qué usarlo

Lazygit es una interfaz visual (TUI) para git que corre dentro de tu terminal. No reemplaza los comandos de git — los vuelve visuales, más rápidos, y te obliga a revisar cada cambio antes de confirmarlo (en vez de `git add .` a ciegas).

## 2. Instalación

```bash
# Mac
brew install lazygit

# Linux (Ubuntu/Debian)
sudo add-apt-repository ppa:lazygit-team/release
sudo apt update
sudo apt install lazygit
```

## 3. Abrir lazygit

```bash
cd tu-repo
lazygit
```

## 4. Los paneles de la interfaz

| Panel | Qué muestra |
|---|---|
| **Status** | resumen del estado del repo |
| **Files** | archivos modificados (aquí haces stage/unstage) |
| **Branches** | tus ramas locales y remotas |
| **Commits** | historial de commits |
| **Stash** | cambios guardados temporalmente sin commitear |

Navega entre paneles con las flechas o los números que aparecen en la interfaz (usualmente `1`-`5`).

## 5. Flujo básico: stage → commit → push

| Tecla | Acción |
|---|---|
| `space` | stage/unstage el archivo bajo el cursor |
| `a` | stage/unstage TODOS los archivos a la vez |
| `c` | crear commit (abre input para el mensaje) |
| `C` | commit usando el editor configurado (para mensajes largos) |
| `P` (mayúscula) | push |
| `p` (minúscula) | pull |
| `enter` | expandir archivo para ver el diff línea por línea |
| `d` | ver diff del archivo seleccionado |

## 6. Stage por "hunk" (pedazo específico, no el archivo completo)

Útil cuando un mismo archivo tiene cambios que quieres separar en commits distintos:

1. Selecciona el archivo, presiona `enter` para entrar al diff detallado
2. Selecciona las líneas específicas del cambio
3. `space` → stagea SOLO esa parte, no el archivo entero

## 7. Ramas (branches)

| Tecla | Acción |
|---|---|
| `n` | crear rama nueva |
| `space` / `enter` (sobre una rama) | hacer checkout (pararte en esa rama) |
| `M` (mayúscula) | mergear la rama seleccionada hacia donde estás parado |
| `d` | borrar rama (pide confirmación) |
| `r` | rebase de la rama seleccionada sobre donde estás parado |

**Concepto clave:** `main` debe mantenerse siempre estable. Los experimentos van en ramas nuevas — si el experimento sale mal, simplemente borras la rama y `main` nunca se enteró.

## 8. Deshacer y corregir

| Tecla | Acción |
|---|---|
| `z` | undo de la última acción de git realizada en lazygit |
| `Ctrl+z` (en algunos setups) | redo |
| `r` (sobre un commit en el panel de Commits) | reword — cambiar el mensaje de un commit ya hecho |
| `s` (sobre un commit) | squash — combinar con el commit anterior |

## 9. Stash (guardar cambios sin commitear)

| Tecla | Acción |
|---|---|
| `s` (en el panel de Files) | stash de los cambios actuales |
| Panel de Stash → `space` | aplicar (pop) un stash guardado |
| Panel de Stash → `d` | borrar un stash |

Útil cuando quieres cambiar de rama rápidamente sin commitear algo a medias.

## 10. Ver historial y detalles de commits

| Tecla | Acción |
|---|---|
| `enter` (sobre un commit) | ver los archivos que cambiaron en ese commit |
| `enter` de nuevo (sobre un archivo) | ver el diff exacto de ese archivo en ese commit |

## 11. Remotos

Panel de Branches suele incluir remotos (`origin`, etc). Desde ahí puedes:
- Ver ramas remotas
- Hacer checkout de una rama remota que no tienes localmente

## 12. Salir de lazygit

```
q
```

## 13. Integración con Neovim/LazyVim

LazyVim suele traer un atajo (típicamente `<espacio>gg`) que abre lazygit directamente dentro de Neovim, sin salir del editor — revisa `:LazyExtras` o tu config de keymaps para confirmar el atajo exacto en tu instalación.

## 14. Buenas prácticas al usar lazygit

1. **Revisa el diff antes de stagear** (`enter` sobre el archivo) — así detectas console.logs olvidados o código comentado que no querías subir.
2. **Mensajes de commit con formato Conventional Commits:**
   ```
   feat: agregar autenticación con JWT
   fix: corregir validación de formulario
   docs: actualizar README
   chore: actualizar dependencias
   refactor: simplificar lógica de rutas
   ```
3. **Commits pequeños y frecuentes** son más fáciles de revisar y revertir que uno gigante al final del día.
4. **Usa ramas para cualquier experimento** — nunca pruebes cosas riesgosas directo en `main`.

---

## Flujo de trabajo diario recomendado (kitty + lazygit + nvim juntos)

1. Abres kitty, `cd` a tu proyecto
2. `nvim .` para editar
3. Cuando quieras revisar/commitear cambios: `<espacio>gg` (si está configurado) o sales a la terminal y corres `lazygit`
4. Revisas diffs, stageas, commiteas con mensaje claro, push
5. Vuelves a editar

---

## Notas finales

- Kitty y lazygit son herramientas independientes entre sí — cada una tiene su propia configuración y su propio propósito.
- Si algo en kitty tira "Errors parsing configuration" al recargar, casi siempre es una línea duplicada o mal escrita — revisa el número de línea exacto que te indica el error.
