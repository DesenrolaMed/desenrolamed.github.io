@echo off
chcp 65001 > nul
title Atualizando desenrolaMed no GitHub Pages...

echo ========================================================
echo       PUBLICANDO ATUALIZAÇÕES DO DESENROLAMED
echo ========================================================
echo.

:: Garantir que o Git portátil instalado no perfil do usuário esteja no PATH
if exist "%LOCALAPPDATA%\Programs\Git\cmd\git.exe" (
    set "PATH=%LOCALAPPDATA%\Programs\Git\cmd;%PATH%"
)

:: Verificar se o Git está instalado
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] O Git ainda não está instalado no seu computador!
    echo Por favor, instale o Git para poder atualizar automaticamente.
    echo Baixe em: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo [1/3] Identificando alterações no banco de dados...
git add index.html desenrolaMed.html desenrolaMed_Amigos.html .gitignore

echo [2/3] Registrando as alterações...
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do set d=%%a-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ("%time%") do set t=%%a:%%b
git commit -m "Atualização do banco de dados (%d% %t%)"

echo [3/3] Enviando para o site online no GitHub...
git push

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo    ✅ SUCESSO! SEU SITE FOI ATUALIZADO NA NUVEM!
    echo ========================================================
    echo Em cerca de 1 a 2 minutos as mudanças estarão visíveis
    echo para todos que acessarem o link do seu site.
    echo.
) else (
    echo.
    echo ========================================================
    echo    ⚠️ HOUVE UM PROBLEMA AO ENVIAR.
    echo ========================================================
    echo Verifique sua conexão com a internet ou se o repositório
    echo remoto está configurado corretamente.
    echo.
)

pause
