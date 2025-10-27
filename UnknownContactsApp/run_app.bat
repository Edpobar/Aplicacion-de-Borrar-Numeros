@echo off
echo ========================================
echo    UNKNOWN CONTACTS MANAGER
echo    Script de Ejecucion
echo ========================================
echo.

echo [1/4] Verificando Flutter...
flutter doctor
if %errorlevel% neq 0 (
    echo ERROR: Flutter no esta instalado o configurado correctamente
    pause
    exit /b 1
)

echo.
echo [2/4] Instalando dependencias...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: No se pudieron instalar las dependencias
    pause
    exit /b 1
)

echo.
echo [3/4] Limpiando cache...
flutter clean
flutter pub get

echo.
echo [4/4] Ejecutando aplicacion...
echo.
echo ========================================
echo    INFORMACION DE USO
echo    (Credenciales de login en lib/pages/login_page.dart)
echo ========================================
echo.

flutter run --debug

pause
