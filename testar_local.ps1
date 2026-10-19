# Gera o dashboard no seu computador para teste (Windows PowerShell).
# Uso: na pasta do projeto, rode  .\testar_local.ps1
# O token e a senha são pedidos na hora e não ficam salvos em nenhum arquivo.
 
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
 
$token = Read-Host "Token da API do Acessórias" -AsSecureString
$senha = Read-Host "Senha do painel (Enter = sem senha, só para teste local)" -AsSecureString
 
$env:ACESSORIAS_TOKEN = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))
$env:PAINEL_SENHA     = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($senha))
$env:PYTHONIOENCODING = "utf-8"
 
try {
    python -m pip install --quiet cryptography
    Write-Host "Buscando dados no Acessórias (cerca de 15 minutos)..." -ForegroundColor Cyan
    python jp_dashboard.py --out index.html
    Write-Host "Pronto. Abrindo index.html..." -ForegroundColor Green
    Start-Process (Join-Path $PSScriptRoot "index.html")
}
finally {
    Remove-Item Env:ACESSORIAS_TOKEN, Env:PAINEL_SENHA -ErrorAction SilentlyContinue
}