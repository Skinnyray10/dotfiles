# Referencia Completa de LazyVim

Guía de referencia para consulta continua. No está pensada para memorizar de golpe — úsala como diccionario cuando se te olvide un comando.

---

## 1. Fundamentos: los modos de Vim

| Modo | Cómo entrar | Para qué sirve |
|---|---|---|
| **Normal** | `Esc` (default al abrir) | Navegar, ejecutar comandos, editar por movimientos |
| **Insert** | `i`, `a`, `o`, `O` | Escribir texto |
| **Visual** | `v`, `V`, `Ctrl+v` | Seleccionar texto |
| **Command** | `:` | Comandos tipo `:w`, `:q`, `:%s/.../.../` |
| **Terminal** | `Ctrl+/` (LazyVim) o `:terminal` | Terminal embebida |

**Regla de oro:** vives en Normal mode. Entras a Insert solo para escribir, y vuelves a Normal con `Esc`.

**Variantes para entrar a Insert mode:**
| Tecla | Acción |
|---|---|
| `i` | insertar antes del cursor |
| `a` | insertar después del cursor |
| `I` | insertar al inicio de la línea |
| `A` | insertar al final de la línea |
| `o` | nueva línea abajo, entra a Insert |
| `O` | nueva línea arriba, entra a Insert |

---

## 2. Movimiento básico

| Tecla | Acción |
|---|---|
| `h` `j` `k` `l` | izquierda / abajo / arriba / derecha |
| `w` | salta al inicio de la siguiente palabra |
| `b` | salta al inicio de la palabra anterior |
| `e` | salta al final de la palabra actual/siguiente |
| `0` | inicio de línea (columna 0) |
| `^` | primer carácter no vacío de la línea |
| `$` | fin de línea |
| `gg` | inicio del archivo |
| `G` | fin del archivo |
| `{número}G` o `:número` | ir a la línea N (ej. `42G`) |
| `%` | saltar entre paréntesis/llaves/corchetes que hacen par |
| `Ctrl+d` | media página abajo |
| `Ctrl+u` | media página arriba |
| `Ctrl+f` | página completa abajo |
| `Ctrl+b` | página completa arriba |
| `H` / `M` / `L` | tope / medio / fondo de la pantalla visible |

---

## 3. Edición esencial

| Tecla | Acción |
|---|---|
| `x` | borrar carácter bajo el cursor |
| `dd` | borrar línea completa |
| `dw` | borrar palabra |
| `d$` | borrar hasta el final de la línea |
| `d0` | borrar hasta el inicio de la línea |
| `yy` | copiar (yank) línea |
| `yw` | copiar palabra |
| `p` | pegar después del cursor |
| `P` | pegar antes del cursor |
| `u` | deshacer |
| `Ctrl+r` | rehacer |
| `.` | repetir la última acción de edición |
| `cc` | borra la línea y entra a Insert (cambiar línea) |
| `cw` | borra la palabra y entra a Insert |
| `r{char}` | reemplaza un solo carácter |
| `~` | cambia mayúscula/minúscula del carácter |
| `J` | une la línea actual con la siguiente |
| `>>` / `<<` | indentar / des-indentar línea |

**Combinando "operador + movimiento" (el patrón más poderoso de Vim):**
Cualquier operador (`d`, `y`, `c`) se puede combinar con cualquier movimiento:
```
d}    → borra hasta el siguiente párrafo
y$    → copia hasta el fin de línea
c2w   → cambia las siguientes 2 palabras
```

**Text objects (aún más poderoso):**
| Combo | Acción |
|---|---|
| `diw` | borra la palabra bajo el cursor (dentro de la palabra) |
| `daw` | borra la palabra + el espacio siguiente |
| `di"` | borra el contenido dentro de comillas |
| `da"` | borra el contenido + las comillas |
| `dip` | borra el párrafo actual |
| `dit` | borra el contenido dentro de una etiqueta HTML/JSX |
| `dat` | borra la etiqueta completa incluyendo tags |
| `di(` / `di{` / `di[` | borra dentro de paréntesis/llaves/corchetes |

---

## 4. Visual mode (selección)

| Tecla | Acción |
|---|---|
| `v` | selección de caracteres |
| `V` | selección de líneas completas |
| `Ctrl+v` | selección en bloque (columna) — útil para editar múltiples líneas a la vez |
| `gv` | reselecciona la última selección visual |
| `o` (dentro de visual) | mueve el otro extremo de la selección |

Con algo seleccionado, puedes aplicar operadores: `d` (borrar), `y` (copiar), `c` (cambiar), o `>`/`<` (indentar).

---

## 5. Registros y portapapeles del sistema

| Tecla | Acción |
|---|---|
| `"+y` | copiar al portapapeles REAL del sistema (para pegar en otras apps) |
| `"+p` | pegar desde el portapapeles del sistema |
| `"ayy` | copiar línea al registro con nombre "a" |
| `"ap` | pegar desde el registro "a" |
| `:reg` | ver todos los registros actuales |

Por default, `yy`/`p` usan el registro interno de Vim, no el del sistema operativo — para compartir con otras apps siempre usa `"+`.

---

## 6. Macros

Graban una secuencia de acciones para repetirla:

```
qa          → empieza a grabar en el registro "a"
(ediciones)
q           → detiene la grabación
@a          → ejecuta la macro una vez
5@a         → ejecuta la macro 5 veces
@@          → repite la última macro ejecutada
```

Ideal para cambios repetitivos en múltiples líneas (agregar un prefijo, formatear, etc).

---

## 7. Buffers, ventanas y tabs (el cambio mental viniendo de VSCode)

- **Buffer** = un archivo cargado en memoria (equivalente aproximado a una "pestaña" de VSCode).
- **Ventana (window)** = una división visual de la pantalla que muestra un buffer.
- **Tab** = un layout completo de ventanas. En LazyVim casi no se usa; navegas por buffers en vez de tabs.

| Atajo LazyVim | Acción |
|---|---|
| `<espacio><espacio>` | buscar archivos (Telescope/Snacks picker) |
| `<espacio>,` | buscar entre buffers abiertos |
| `Shift+h` / `Shift+l` | buffer anterior / siguiente |
| `<espacio>bd` | cerrar buffer actual |
| `Ctrl+w s` | split horizontal |
| `Ctrl+w v` | split vertical |
| `Ctrl+w w` | saltar entre ventanas |
| `Ctrl+w h/j/k/l` | moverse a la ventana en esa dirección |
| `Ctrl+w q` | cerrar la ventana actual |
| `Ctrl+w =` | igualar tamaño de todas las ventanas |

---

## 8. Which-key (tu mapa de comandos)

Presiona `<espacio>` y espera — aparece un menú con todos los comandos agrupados por categoría (buscar, código, git, ventanas, etc). Es la forma más rápida de descubrir atajos sin memorizar todo de golpe.

---

## 9. Telescope / Snacks Picker (búsqueda)

| Atajo | Acción |
|---|---|
| `<espacio><espacio>` | buscar archivos por nombre |
| `<espacio>fg` o `<espacio>/` | buscar texto (grep) en todo el proyecto |
| `<espacio>fb` | buscar entre buffers abiertos |
| `<espacio>fr` | archivos recientes |
| `<espacio>fw` | buscar la palabra bajo el cursor en el proyecto |
| Dentro del picker: `Ctrl+j`/`Ctrl+k` | moverse entre resultados |
| Dentro del picker: `Ctrl+x` / `Ctrl+v` | abrir resultado en split horizontal/vertical |

---

## 10. LSP (Language Server Protocol) — la parte "inteligente"

| Atajo | Acción |
|---|---|
| `gd` | ir a la definición |
| `gD` | ir a la declaración |
| `gr` | ver todas las referencias (dónde se usa esto) |
| `gI` | ir a la implementación |
| `K` | documentación flotante del símbolo bajo el cursor |
| `<espacio>ca` | code actions (auto-fix, agregar import, refactors) |
| `<espacio>rn` | renombrar símbolo en todo el proyecto |
| `<espacio>cf` | formatear archivo (Prettier vía conform.nvim) |
| `<espacio>cd` | ver diagnóstico (error/warning) de la línea actual |
| `]d` / `[d` | saltar al siguiente / anterior error o warning |
| `<espacio>cl` | ver info del LSP attachado (`:LspInfo` hace lo mismo) |

**Comandos útiles relacionados:**
```
:LspInfo       → qué LSP está corriendo en el buffer actual
:Mason         → gestor de LSPs/linters/formatters instalados
:checkhealth   → diagnóstico general de salud de Neovim
```

---

## 11. Treesitter (entendimiento de sintaxis)

| Atajo | Acción |
|---|---|
| `]f` / `[f` | saltar al inicio de la siguiente/anterior función |
| `]c` / `[c` | saltar entre clases |

```
:TSUpdate      → actualiza los parsers de Treesitter
:TSInstall X   → instala el parser para el lenguaje X manualmente
```

---

## 12. Neo-tree (explorador de archivos)

| Atajo | Acción |
|---|---|
| `<espacio>e` | abrir/cerrar el explorador de archivos |
| Dentro de neo-tree: `a` | crear archivo nuevo |
| Dentro de neo-tree: `d` | borrar archivo |
| Dentro de neo-tree: `r` | renombrar |
| Dentro de neo-tree: `Enter` | abrir archivo/carpeta |
| Dentro de neo-tree: `H` | mostrar/ocultar archivos ocultos |

---

## 13. Git integrado (gitsigns)

| Atajo | Acción |
|---|---|
| `]h` / `[h` | saltar al siguiente/anterior "hunk" (cambio) |
| `<espacio>ghs` | stage del hunk actual |
| `<espacio>ghr` | reset/descartar el hunk actual |
| `<espacio>ghp` | preview del cambio (diff) |
| `<espacio>gg` | abrir lazygit dentro de Neovim (si está configurado) |

Los cambios sin commitear se marcan con una barra de color en el margen izquierdo (verde = agregado, azul = modificado, rojo = borrado).

---

## 14. Búsqueda y reemplazo dentro de un archivo

| Comando | Acción |
|---|---|
| `/palabra` | buscar hacia adelante |
| `?palabra` | buscar hacia atrás |
| `n` / `N` | siguiente / anterior resultado |
| `*` | buscar la palabra bajo el cursor, hacia adelante |
| `:%s/viejo/nuevo/g` | reemplazar TODAS las ocurrencias en el archivo |
| `:%s/viejo/nuevo/gc` | igual, pero pide confirmación por cada una |
| `:s/viejo/nuevo/g` | reemplazar solo en la línea actual |

---

## 15. Marcas (marks) — navegación rápida en archivos grandes

```
ma          → crea la marca "a" en la posición actual
`a          → salta exactamente a la marca "a"
'a          → salta al inicio de línea de la marca "a"
```

---

## 16. Plegado de código (folding)

| Tecla | Acción |
|---|---|
| `za` | abre/cierra el fold bajo el cursor |
| `zR` | abre todos los folds |
| `zM` | cierra todos los folds |

---

## 17. Terminal integrada

```
<espacio>ft    → abre terminal flotante (atajo típico de LazyVim)
Ctrl+\         → alterna terminal (según config)
```
Dentro de la terminal, `Esc` te saca del modo de inserción de la terminal para poder navegar con movimientos normales de Vim sobre el output.

---

## 18. Gestión de plugins con Lazy

```
:Lazy           → abre el dashboard del plugin manager
```
Dentro del dashboard:
| Tecla | Acción |
|---|---|
| `I` | instalar plugins pendientes |
| `U` | actualizar todos los plugins |
| `S` | sync (instala + limpia lo que ya no está en config) |
| `X` | eliminar plugins que ya no están en tu config |
| `L` | ver logs/changelog de los plugins |
| `R` | restaurar a las versiones fijadas en `lazy-lock.json` |

---

## 19. LazyExtras (activar capacidades por lenguaje)

```
:LazyExtras
```
Lista de módulos preconfigurados por lenguaje/función (`lang.typescript`, `lang.json`, `linting.eslint`, `formatting.prettier`, `ai.claudecode`, etc). Navega con `j`/`k`, activa/desactiva con `x`, sal con `q`.

---

## 20. Sesiones (retomar tu último estado de trabajo)

```
:mksession ~/.config/nvim/session.vim   → guarda la sesión actual
:source ~/.config/nvim/session.vim      → restaura esa sesión
```
LazyVim también puede tener un plugin de sesiones automáticas (`persistence.nvim`) con un atajo tipo `<espacio>qs` para restaurar la última sesión al abrir Neovim en una carpeta.

---

## 21. Comandos de salud y diagnóstico

```
:checkhealth        → diagnóstico general (dependencias, providers, clipboard)
:LspInfo             → LSPs activos en el buffer actual
:Mason               → gestor de LSPs/formatters/linters
:Lazy                → gestor de plugins
:LazyExtras          → gestor de extras por lenguaje
```

---

## 22. Flujo de trabajo recomendado para JS/TS (tu stack)

1. `<espacio><espacio>` → abre el archivo que necesitas
2. Edita con text objects (`ciw`, `di"`, etc) en vez de borrar carácter por carácter
3. `gd` para saltar a definiciones, `gr` para ver dónde se usa algo
4. `<espacio>ca` cuando el LSP marque un error para ver soluciones automáticas
5. `<espacio>cf` para formatear antes de guardar
6. `<espacio>gg` para revisar tu diff y commitear sin salir de Neovim

---

## Notas finales

- No memorices todo de golpe — usa `<espacio>` + which-key para descubrir, y ven a este documento cuando se te olvide algo puntual.
- Los atajos con `<espacio>` son específicos de LazyVim (definidos en `lua/config/keymaps.lua` y los plugins); los que no llevan `<espacio>` (como `dd`, `yy`, `gd`) son de Vim/Neovim puro y funcionan igual en cualquier distribución.
