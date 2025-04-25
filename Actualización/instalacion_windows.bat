@echo off
:: Verificar si se tienen permisos de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Este script necesita permisos de administrador.
    echo Solicitando permisos...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Manejo de errores para la instalación de Python
echo Verificando instalación de Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python no está instalado o no está configurado correctamente.
    echo Solución: Descargando e instalando Python...
    powershell -Command "Start-Process 'https://www.python.org/ftp/python/3.10.9/python-3.10.9-amd64.exe' -Wait"
    if %errorlevel% neq 0 (
        echo Error al descargar o instalar Python. Verifica tu conexión a internet o instala Python manualmente desde https://www.python.org/.
        exit /b
    )
)

:: Manejo de errores para la instalación de dependencias
echo Instalando dependencias...
pip install --upgrade pip >nul 2>&1
if %errorlevel% neq 0 (
    echo Error al actualizar pip. Solución: Verifica que pip esté instalado correctamente o reinstálalo con "python -m ensurepip".
    exit /b
)

pip install google-api-python-client google-auth pandas openpyxl >nul 2>&1
if %errorlevel% neq 0 (
    echo Error al instalar las dependencias. Solución: Verifica tu conexión a internet o instala las dependencias manualmente con:
    echo pip install google-api-python-client google-auth pandas openpyxl
    exit /b
)

echo Instalación completada correctamente.
pause
