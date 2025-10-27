@echo off
title Compilador Flutter Automático - by Sofia
color 0A

echo.

REM Ir até à pasta do projeto
cd /d "%~dp0"
echo 📍 O script está executando na pasta:
echo    %cd%
echo.
pause

REM --- VERIFICAÇÃO DE AMBIENTE ---
echo 🔍 Verificando se o comando 'flutter' está disponível...
echo    (Se a janela fechar aqui, o problema está na sua instalação do Flutter ou no PATH do sistema)
echo.
flutter --version
if %errorlevel% neq 0 (
    echo.
    echo ❌ ERRO: O comando 'flutter' não foi encontrado ou falhou ao executar.
    echo    Por favor, verifique se o Flutter SDK está instalado e se a pasta 'flutter\bin'
    echo    foi adicionada corretamente às variáveis de ambiente (PATH) do seu sistema.
    echo.
    echo    Para diagnosticar, abra uma nova janela de 'CMD' e execute o comando: flutter doctor
    echo.
    pause
    exit /b 1
)
echo ✅ Flutter encontrado!
echo.
pause

REM --- VERIFICAÇÃO DO AMBIENTE ANDROID (JAVA/GRADLE) ---
echo ☕ Verificando o ambiente de compilação Android (Java/Gradle)...
echo    (Se a janela fechar aqui, o problema provavelmente é com a instalação do Java JDK)
echo.

REM Navega para a pasta android e executa um comando simples do gradle
cd android
echo ⏳ Executando 'gradlew.bat -v'. Isso pode demorar um pouco...
REM A saída deste comando será guardada em build_log.txt para diagnóstico
echo. > ..\build_log.txt
echo --- Verificando Gradle --- >> ..\build_log.txt
call gradlew.bat -v >> ..\build_log.txt 2>&1

if %errorlevel% neq 0 (
    cd ..
    echo.
    echo ❌ ERRO: Falha ao executar o Gradle.
    echo    Isso geralmente é causado por um problema com a instalação do Java (JDK).
    echo.
    echo    COMO SOLUCIONAR:
    echo    1. Revise o arquivo 'build_log.txt' para ver a mensagem de erro específica.
    echo    2. Verifique se a variável de ambiente JAVA_HOME está apontando para a pasta do JDK.
    echo    3. Execute 'flutter doctor -v' em uma nova janela de 'CMD' para um diagnóstico detalhado.
    echo.
    pause
    exit /b 1
)

cd ..
echo ✅ Ambiente Android (Java/Gradle) verificado com sucesso!
echo.
pause

REM Limpeza do projeto
echo 🧹 Limpando o projeto (flutter clean)...
echo    (A saída deste comando será guardada em build_log.txt)
echo.
flutter clean >> build_log.txt 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERRO: Falha ao executar 'flutter clean'. Verifique a instalação do Flutter.
    echo    Por favor, revise o arquivo 'build_log.txt' para ver os detalhes do erro.
    echo.
    pause
    exit /b 1
)
echo ✅ Limpeza concluída.

REM Reinstalar dependências
echo 📦 Reinstalando dependências...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ ERRO: Falha ao executar 'flutter pub get'. Verifique o arquivo pubspec.yaml e sua conexão com a internet.
    echo.
    echo    Por favor, revise o arquivo 'build_log.txt' para ver os detalhes do erro.
    echo.
    pause
    exit /b 1
)

REM Compilar APK
echo 🚀 Compilando APK final...
echo    (Este passo pode demorar vários minutos)
echo.
flutter build apk --release >> build_log.txt 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERRO: A compilação do APK falhou. Verifique os logs de erro acima para mais detalhes.
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Processo concluído com sucesso!
echo.
echo 📂 Abrindo pasta de saída...
explorer "build\app\outputs\flutter-apk"

echo.
echo Pressione qualquer tecla para fechar esta janela...
pause
