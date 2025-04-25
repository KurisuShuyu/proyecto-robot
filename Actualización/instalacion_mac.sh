#!/bin/bash

# Verificar si se tienen permisos de administrador
if [ "$EUID" -ne 0 ]; then
    echo "Este script necesita permisos de administrador. Ejecútalo con 'sudo'."
    exit 1
fi

# Manejo de errores para la instalación de Python
echo "Verificando instalación de Python..."
if ! command -v python3 &> /dev/null; then
    echo "Python no está instalado o no está configurado correctamente."
    echo "Solución: Instalando Python..."
    brew update && brew install python3
    if [ $? -ne 0 ]; then
        echo "Error al instalar Python. Verifica que Homebrew esté instalado correctamente o instala Python manualmente desde https://www.python.org/."
        exit 1
    fi
fi

# Manejo de errores para la instalación de dependencias
echo "Instalando dependencias..."
pip3 install --upgrade pip > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error al actualizar pip. Solución: Verifica que pip esté instalado correctamente o reinstálalo con 'brew install python3'."
    exit 1
fi

pip3 install google-api-python-client google-auth pandas openpyxl > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error al instalar las dependencias. Solución: Verifica tu conexión a internet o instala las dependencias manualmente con:"
    echo "pip3 install google-api-python-client google-auth pandas openpyxl"
    exit 1
fi

echo "Instalación completada correctamente."
