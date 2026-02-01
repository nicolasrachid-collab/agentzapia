# Script para baixar os vídeos do site Leadster para assets/videos
# Execute no PowerShell: .\baixar-videos.ps1

$baseUrl = "https://leadster.com.br"
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$root = $PSScriptRoot
$v1 = Join-Path $root "assets\videos\pages\home\v1"
$ws = Join-Path $root "assets\videos\pages\whatsapp-suite"

$videos = @(
    @{ url = "$baseUrl/videos/pages/home/v1/channels-website.mp4"; out = "$v1\channels-website.mp4" },
    @{ url = "$baseUrl/videos/pages/home/v1/channels-shopbot.mp4"; out = "$v1\channels-shopbot.mp4" },
    @{ url = "$baseUrl/videos/pages/home/v1/cta-video.mp4"; out = "$v1\cta-video.mp4" },
    @{ url = "$baseUrl/videos/pages/whatsapp-suite/banner-video.mp4"; out = "$ws\banner-video.mp4" }
)

1..6 | ForEach-Object {
    $n = "{0:D2}" -f $_
    $videos += @{ url = "$baseUrl/videos/pages/home/v1/optimize-$n.mp4"; out = "$v1\optimize-$n.mp4" }
}

$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    "Accept"     = "*/*"
}

foreach ($v in $videos) {
    $name = Split-Path $v.out -Leaf
    try {
        Write-Host "Baixando $name ..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $v.url -OutFile $v.out -UseBasicParsing -Headers $headers
        $size = (Get-Item $v.out).Length
        Write-Host "  OK ($([math]::Round($size/1KB)) KB)" -ForegroundColor Green
    } catch {
        Write-Host "  ERRO: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nConcluído. Verifique os arquivos em assets\videos\" -ForegroundColor Yellow
