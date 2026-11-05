@echo off
title Atualizando desenrolaMed no GitHub e Cloudflare...

echo ========================================================
echo       PUBLICANDO ATUALIZACOES DO DESENROLAMED
echo ========================================================
echo.

set "PATH=%LOCALAPPDATA%\Programs\Git\cmd;%LOCALAPPDATA%\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin;%PATH%"

echo [1/3] Identificando alteracoes no banco de dados...
call git add -A

echo [2/3] Registrando as alteracoes...
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do set d=%%a-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ("%time%") do set t=%%a:%%b
call git commit -m "Atualizacao do banco de dados (%d% %t%)"

echo [3/3] Enviando para o site online...
call git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo    SUCESSO! SEU SITE FOI ATUALIZADO NA NUVEM!
    echo ========================================================
    echo Suas mudancas foram enviadas com sucesso!
    echo.
) else (
    echo.
    echo ========================================================
    echo    HOUVE UM PROBLEMA AO ENVIAR.
    echo ========================================================
    echo Verifique sua conexao ou execute CONECTAR_PRIMEIRA_VEZ.bat
    echo.
)

pause
