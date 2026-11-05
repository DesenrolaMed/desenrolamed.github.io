@echo off
title Conectar DesenrolaMed ao GitHub

echo ========================================================
echo       CONECTANDO SEU PROJETO AO GITHUB
echo ========================================================
echo.

set "PATH=%LOCALAPPDATA%\Programs\Git\cmd;%LOCALAPPDATA%\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin;%PATH%"

echo [1/3] Fazendo login na sua conta do GitHub...
echo.
echo Uma pagina sera aberta no seu navegador para autorizar o acesso.
echo Se pedir um codigo de 8 letras/numeros, digite o codigo exibido abaixo.
echo Depois clique no botao verde "Authorize github".
echo.

call gh auth login --web -p https -h github.com

echo.
echo [2/3] Configurando credenciais do Git...
call gh auth setup-git

echo.
echo [3/3] Enviando seu projeto e banco de dados para o GitHub...
call git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo    SUCESSO! SEU PROJETO FOI PUBLICADO NO GITHUB!
    echo ========================================================
    echo.
    echo Seus arquivos estao salvos com sucesso na nuvem.
    echo.
) else (
    echo.
    echo ========================================================
    echo    Houve um problema no envio. Verifique o login acima.
    echo ========================================================
)

echo.
pause
