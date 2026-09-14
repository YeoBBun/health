# legend.html (artifact fragment) -> app/index.html (standalone PWA document)
# Re-run after editing legend.html to refresh app/index.html.
#
# Korean literals are built from code points on purpose: Windows PowerShell 5.1
# reads .ps1 files as ANSI when there is no BOM, which mangles inline Hangul.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src  = Join-Path $root "legend.html"
$out  = Join-Path $root "app\index.html"

$appTitle = [string]::Concat([char]0xB9E8, [char]0xBAB8, ' ', [char]0xC6B4, [char]0xB3D9)  # "맨몸 운동"

$raw = Get-Content -Path $src -Raw -Encoding UTF8

$marker = "</style>"
$i = $raw.IndexOf($marker)
if ($i -lt 0) { throw "Could not find </style> in legend.html" }

$headPart = $raw.Substring(0, $i + $marker.Length)
$bodyPart = $raw.Substring($i + $marker.Length)

$head = @'
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#141110">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="__APP_TITLE__">
<link rel="manifest" href="manifest.json">
<link rel="apple-touch-icon" href="icons/icon-192.png">
<style>
html{color-scheme:dark;-webkit-text-size-adjust:100%}
body{margin:0;background:#141110;overscroll-behavior-y:contain}
img{max-width:100%}
[hidden]{display:none!important}
</style>
'@

$tail = @'

<script>
if ("serviceWorker" in navigator) {
  window.addEventListener("load", function () {
    navigator.serviceWorker.register("sw.js").catch(function () {});
  });
}
</script>
</body>
</html>
'@

$head = $head.Replace("__APP_TITLE__", $appTitle)

$doc = $head + "`r`n" + $headPart + "`r`n</head>`r`n<body>`r`n" + $bodyPart + $tail

$appDir = Join-Path $root "app"
if (-not (Test-Path $appDir)) { New-Item -ItemType Directory -Path $appDir | Out-Null }

$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($out, $doc, $utf8)

Write-Output ("Built app/index.html - {0:N0} bytes" -f (Get-Item $out).Length)
