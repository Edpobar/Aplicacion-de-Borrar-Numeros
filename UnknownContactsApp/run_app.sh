#!/bin/bash

echo "========================================"
echo "    UNKNOWN CONTACTS MANAGER"
echo "    Script de Ejecucion"
echo "========================================"
echo

echo "[1/4] Verificando Flutter..."
flutter doctor
if [ $? -ne 0 ]; then
    echo "ERROR: Flutter no esta instalado o configurado correctamente"
    exit 1
fi

echo
echo "[2/4] Instalando dependencias..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "ERROR: No se pudieron instalar las dependencias"
    exit 1
fi

echo
echo "[3/4] Limpiando cache..."
flutter clean
flutter pub get

echo
echo "[4/4] Ejecutando aplicacion..."
echo
echo "========================================"
echo "    INFORMACION DE USO"
echo "    (Credenciales de login en lib/pages/login_page.dart)"
echo "========================================"
echo

flutter run --debug
