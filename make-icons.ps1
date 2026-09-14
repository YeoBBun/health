# 앱 아이콘 생성 (192 / 512 / maskable 512)
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dir  = Join-Path $root "app\icons"
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

$bg    = [System.Drawing.Color]::FromArgb(20, 17, 16)
$brass = [System.Drawing.Color]::FromArgb(227, 166, 79)

function New-RoundRect($x, $y, $w, $h, $r) {
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r * 2
  $p.AddArc($x, $y, $d, $d, 180, 90)
  $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
  $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $p.CloseFigure()
  return $p
}

function Build-Icon($size, $path, $inset) {
  $bmp = New-Object System.Drawing.Bitmap($size, $size)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.Clear($bg)

  # 512 기준 좌표를 size 에 맞게 축소, maskable 은 안쪽으로 더 당김
  $s = ($size / 512.0) * $inset
  $off = ($size - (512.0 * $s)) / 2.0
  function T($v) { return [float](512.0 * 0 + $off + $v * $s) }

  $brush = New-Object System.Drawing.SolidBrush($brass)

  # 철봉 (캔버스 중앙 256 기준 좌우 대칭)
  $bar = New-RoundRect (T 86) (T 125) (340 * $s) (26 * $s) (13 * $s)
  $g.FillPath($brush, $bar); $bar.Dispose()

  # 양팔
  $la = New-RoundRect (T 182) (T 151) (22 * $s) (122 * $s) (11 * $s)
  $g.FillPath($brush, $la); $la.Dispose()
  $ra = New-RoundRect (T 308) (T 151) (22 * $s) (122 * $s) (11 * $s)
  $g.FillPath($brush, $ra); $ra.Dispose()

  # 머리
  $g.FillEllipse($brush, (T 216), (T 187), (80 * $s), (80 * $s))

  # 몸통
  $tr = New-RoundRect (T 226) (T 279) (60 * $s) (108 * $s) (28 * $s)
  $g.FillPath($brush, $tr); $tr.Dispose()

  $brush.Dispose()
  $g.Dispose()
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Output ("  {0}" -f (Split-Path -Leaf $path))
}

Build-Icon 192 (Join-Path $dir "icon-192.png") 1.0
Build-Icon 512 (Join-Path $dir "icon-512.png") 1.0
Build-Icon 512 (Join-Path $dir "icon-maskable-512.png") 0.68

Write-Output "아이콘 생성 완료"
