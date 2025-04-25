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
    sudo apt update && sudo apt install -y python3 python3-pip
    if [ $? -ne 0 ]; then
        echo "Error al instalar Python. Verifica tu conexión a internet o instala Python manualmente."
        exit 1
    fi
fi

# Manejo de errores para la instalación de dependencias
echo "Instalando dependencias..."
pip3 install --upgrade pip > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error al actualizar pip. Solución: Verifica que pip esté instalado correctamente o reinstálalo con 'sudo apt install python3-pip'."
    exit 1
fi

pip3 install google-api-python-client google-auth pandas openpyxl > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error al instalar las dependencias. Solución: Verifica tu conexión a internet o instala las dependencias manualmente con:"
    echo "pip3 install google-api-python-client google-auth pandas openpyxl"
    exit 1
fi

echo "Instalación completada correctamente."
