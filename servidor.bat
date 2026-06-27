@echo off
title Venezuela Ayuda - Servidor Local
echo ========================================
echo  Venezuela Ayuda - Servidor Local
echo ========================================
echo.

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do set IP=%%a
set IP=%IP: =%
echo  Tu IP local: %IP%:8000
echo  Local:       http://localhost:8000
echo  Red local:   http://%IP%:8000
echo.
echo  Dale la direccion de arriba a quien quieras
echo  que este en la misma red WiFi.
echo.
echo Presiona Ctrl+C para detenerlo
echo.

:: Intentar Python 3 primero
python --version >nul 2>&1
if %errorlevel% equ 0 (
    python -m http.server 8000
    goto :eof
)

:: Si no hay Python, intentar Node
node --version >nul 2>&1
if %errorlevel% equ 0 (
    npx http-server -p 8000 --cors
    goto :eof
)

:: Si no hay ni Python ni Node
echo ERROR: No se encontró Python ni Node.js instalado.
echo.
echo Para usar esta app necesitas:
echo 1. Instalar Python: https://python.org/downloads/
echo 2. O instalar Node.js: https://nodejs.org/
echo.
echo O simplemente abre index.html en tu navegador
echo (algunas funciones pueden no funcionar por CORS).
pause
