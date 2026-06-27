# 🇻🇪 Guía de configuración — Venezuela Ayuda

## Paso 1: Crear Supabase (gratis)

1. Ve a **https://supabase.com** y haz clic en **"Start your project"**
2. Regístrate con GitHub o tu correo
3. Crea un **New project**:
   - **Name:** `venezuela-ayuda`
   - **Database Password:** pon una contraseña segura (guárdala)
   - **Region:** **South America (São Paulo)** — la más cercana a Venezuela
   - **Plan:** **Free** (gratis, sin tarjeta)
4. Espera 1-2 minutos a que se cree

## Paso 2: Configurar la base de datos

1. En Supabase, ve a **SQL Editor** (menú izquierdo)
2. Haz clic en **"New Query"**
3. Abre el archivo **schema.sql** que te di, copia TODO y pégalo
4. Haz clic en **"Run"** (▶)
5. ✅ Listo — las tablas y los centros de acopio reales ya están creados

## Paso 3: Conectar la app

1. En Supabase, ve a **Project Settings > API**
2. Copia estos dos valores:

   | Campo | Dónde está |
   |---|---|
   | **Project URL** | Arriba, empieza con `https://` |
   | **anon public key** | Una cadena larga que empieza con `eyJ...` |

3. Abre el archivo **config.js** con el Bloc de notas
4. Reemplaza los valores:

```js
// ANTES (no funciona):
const APP_CONFIG = {
  supabaseUrl: 'https://tu-proyecto.supabase.co',
  supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  ...

// DESPUÉS (funciona):
const APP_CONFIG = {
  supabaseUrl: 'https://XXXXXXXXXXXX.supabase.co',
  supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9XXXXXXXX...',
  ...
```

5. Guarda el archivo ✅

## Paso 4: Probar la app

1. Abre **index.html** en tu navegador (Chrome, Edge, etc.)
2. Ve a **Cuenta** → **Regístrate** (correo + contraseña)
3. Revisa tu bandeja de entrada y confirma el correo
4. Ve a **Registrar** y crea tu primer centro de ayuda
5. El centro aparece en el mapa después de ser aprobado

## Paso 5: Aprobar centros (tú como moderador)

1. En Supabase, ve a **Table Editor** → **centers**
2. Busca los centros con status `pending`
3. Cámbiales el status a `approved` para que aparezcan en el mapa público

## Paso 6: Publicar (gratis)

**Opción A — GitHub Pages:**
1. Crea cuenta en https://github.com
2. Crea un repo llamado `tudesuso.github.io`
3. Sube los archivos: `index.html`, `config.js`, `schema.sql`
4. En 2 minutos está online en `https://tudesuso.github.io`

**Opción B — Netlify (más fácil):**
1. Ve a https://netlify.com, crea cuenta
2. Arrastra la carpeta al panel
3. Listo

## Archivos del proyecto

```
📁 tu-carpeta/
├── index.html          ← App principal (ábrela en el navegador)
├── config.js           ← Configuración de Supabase (edítalo)
├── schema.sql          ← Base de datos (pégalo en Supabase)
├── .env                ← Plantilla de variables de entorno
└── GUIA_CONFIGURACION.md  ← Esta guía
```

## ¿Pegaste los datos de Supabase en config.js?

Si ya lo hiciste, **yo puedo conectarme a tu Supabase** desde aquí para verificar que todo funciona y ayudarte a seedear más datos. Solo dime cuándo hayas completado los pasos 1-3.
