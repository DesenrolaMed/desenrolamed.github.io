@echo off
chcp 65001 > nul
title Conectar DesenrolaMed ao GitHub

echo ========================================================
echo       CONECTANDO SEU PROJETO AO GITHUB (PRIMEIRA VEZ)
echo ========================================================
echo.

:: Localizar Git e GitHub CLI
set "PATH=%LOCALAPPDATA%\Programs\Git\cmd;%LOCALAPPDATA%\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin;%PATH%"

echo [1/3] Fazendo login na sua conta do GitHub...
echo.
echo Pressione qualquer tecla para abrir a autorizacao no navegador.
echo Se aparecer um codigo de 8 letras/numeros na tela, confirme-o no navegador.
echo Depois, clique em "Authorize github".
echo.
pause

gh auth login --web -p https -h github.com

echo.
echo [2/3] Configurando o envio automatico...
gh auth setup-git

echo.
echo [3/3] Enviando seu site e banco de dados para o GitHub...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo    ✅ PRONTO! SEU PROJETO FOI ENVIADO COM SUCESSO!
    echo ========================================================
    echo.
    echo Agora so falta o ultimo clique para ativar o site online:
    echo 1. Acesse: https://github.com/igorinteraminense/DesenrolaMed/settings/pages
    echo 2. Em 'Branch', selecione 'main' e clique em 'Save'.
    echo 3. Em cerca de 1 minuto, seu site estara no ar em:
    echo    https://igorinteraminense.github.io/DesenrolaMed/
    echo.
    echo Daqui em diante, sempre que editar o banco de dados,
    echo basta dar dois cliques no arquivo 'PUBLICAR_NO_SITE.bat'!
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo    ⚠️ O envio nao foi concluido. Verifique o login acima.
    echo ========================================================
)

echo.
pause
