#requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Title {
    Clear-Host
    Write-Host ''
    Write-Host '  ╔══════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
    Write-Host '  ║          WINDOWS TERMINAL — КАСТОМНЫЕ ТЕМЫ                   ║' -ForegroundColor Cyan
    Write-Host '  ║                      by Disooloo                              ║' -ForegroundColor DarkCyan
    Write-Host '  ╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
    Write-Host ''
}
function Find-Settings {
    $paths = @(
      (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
      (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json'),
      (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows Terminal\settings.json')
    )
    foreach ($p in $paths) { if (Test-Path -LiteralPath $p) { return $p } }
    return $null
}
function Read-Settings($path) {
    $raw = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    # Windows PowerShell 5.1 compatible: deliberately no ConvertFrom-Json -AsHashtable
    return ($raw | ConvertFrom-Json)
}
function Ensure-Property($obj, [string]$name, $value) {
    if ($obj.PSObject.Properties.Name -contains $name) { $obj.$name = $value }
    else { $obj | Add-Member -MemberType NoteProperty -Name $name -Value $value }
}
function Set-Theme([string]$themeName) {
    $path = Find-Settings
    if (-not $path) {
      Write-Host 'Не найден settings.json Windows Terminal.' -ForegroundColor Red
      Write-Host 'Откройте Windows Terminal один раз и повторите запуск.' -ForegroundColor Yellow
      return
    }
    $backup = "$path.terminal-customizer-backup"
    if (-not (Test-Path -LiteralPath $backup)) { Copy-Item -LiteralPath $path -Destination $backup }
    $settings = Read-Settings $path
    if (-not $settings.profiles) { Ensure-Property $settings 'profiles' ([pscustomobject]@{}) }
    if (-not $settings.profiles.defaults) { Ensure-Property $settings.profiles 'defaults' ([pscustomobject]@{}) }
    if (-not $settings.schemes) { Ensure-Property $settings 'schemes' @() }

    $themes = @{
      Cyberpunk = @{ Scheme='TC Cyberpunk'; Font='JetBrainsMono Nerd Font'; Size=12; Opacity=84; Acrylic=$true; Padding='18, 14, 18, 14'; Cursor='filledBox'; Retro=$false; Bg='Cyberpunk.jpg' }
      Dracula = @{ Scheme='TC Dracula'; Font='JetBrainsMono Nerd Font'; Size=12; Opacity=90; Acrylic=$true; Padding='16, 12, 16, 12'; Cursor='bar'; Retro=$false; Bg='Dracula.jpg' }
      Nord = @{ Scheme='TC Nord'; Font='Cascadia Mono'; Size=12; Opacity=94; Acrylic=$false; Padding='18, 14, 18, 14'; Cursor='bar'; Retro=$false; Bg='Nord.jpg' }
      TokyoNight = @{ Scheme='TC Tokyo Night'; Font='JetBrainsMono Nerd Font'; Size=12; Opacity=88; Acrylic=$true; Padding='20, 14, 20, 14'; Cursor='vintage'; Retro=$false; Bg='TokyoNight.jpg' }
      Matrix = @{ Scheme='TC Matrix'; Font='Cascadia Mono'; Size=12; Opacity=86; Acrylic=$true; Padding='12, 10, 12, 10'; Cursor='filledBox'; Retro=$true; Bg='Matrix.jpg' }
      Gruvbox = @{ Scheme='TC Gruvbox'; Font='JetBrainsMono Nerd Font'; Size=12; Opacity=92; Acrylic=$false; Padding='18, 12, 18, 12'; Cursor='bar'; Retro=$false; Bg='Gruvbox.jpg' }
      Ocean = @{ Scheme='TC Ocean'; Font='JetBrainsMono Nerd Font'; Size=13; Opacity=86; Acrylic=$true; Padding='22, 16, 22, 16'; Cursor='bar'; Retro=$false; Bg='Ocean.jpg' }
      Solarized = @{ Scheme='TC Solarized'; Font='Cascadia Mono'; Size=12; Opacity=94; Acrylic=$false; Padding='16, 12, 16, 12'; Cursor='bar'; Retro=$false; Bg='Solarized.jpg' }
    }
    $palette = @{
      Cyberpunk=@('#050819','#F8F8F2','#00E5FF','#FF00AA','#1B1D3A','#FF4DCE','#00E5FF','#FF00AA','#F8F8F2','#FF5555','#50FA7B','#F1FA8C','#BD93F9','#8BE9FD','#FF79C6','#282A36')
      Dracula=@('#282A36','#F8F8F2','#BD93F9','#FF79C6','#44475A','#FF79C6','#BD93F9','#FF5555','#F8F8F2','#FF5555','#50FA7B','#F1FA8C','#BD93F9','#8BE9FD','#FF79C6','#44475A')
      Nord=@('#2E3440','#ECEFF4','#88C0D0','#A3BE8C','#3B4252','#BF616A','#A3BE8C','#D08770','#E5E9F0','#BF616A','#A3BE8C','#EBCB8B','#81A1C1','#B48EAD','#8FBCBB','#4C566A')
      TokyoNight=@('#1A1B26','#C0CAF5','#7AA2F7','#BB9AF7','#24283B','#F7768E','#9ECE6A','#E0AF68','#C0CAF5','#F7768E','#9ECE6A','#E0AF68','#7AA2F7','#BB9AF7','#7DCFFF','#414868')
      Matrix=@('#001006','#B8FFC9','#00FF5A','#00A83B','#002B10','#00FF5A','#00A83B','#00D94F','#B8FFC9','#FF4444','#00FF5A','#B6FF00','#00C853','#00FF9C','#8CFFB0','#003B16')
      Gruvbox=@('#282828','#EBDBB2','#FABD2F','#FE8019','#3C3836','#CC241D','#98971A','#D79921','#EBDBB2','#CC241D','#98971A','#D79921','#458588','#B16286','#689D6A','#504945')
      Ocean=@('#03162A','#D8F3FF','#00BEDC','#306EFF','#082A45','#FF6B9D','#00BEDC','#FFD166','#EAFBFF','#FF6B6B','#8CE99A','#FFD166','#74C0FC','#B197FC','#63E6BE','#17466A')
      Solarized=@('#002B36','#839496','#2AA198','#B58900','#073642','#DC322F','#859900','#B58900','#EEE8D5','#DC322F','#859900','#B58900','#268BD2','#D33682','#2AA198','#586E75')
    }
    $p = $themes[$themeName]
    $colors = $palette[$themeName]
    $scheme = [ordered]@{ name=$p.Scheme; background=$colors[0]; foreground=$colors[1]; cursorColor=$colors[2]; selectionBackground=$colors[4]; black=$colors[0]; red=$colors[5]; green=$colors[6]; yellow=$colors[7]; blue=$colors[12]; purple=$colors[13]; cyan=$colors[14]; white=$colors[8]; brightBlack=$colors[15]; brightRed=$colors[9]; brightGreen=$colors[10]; brightYellow=$colors[11]; brightBlue=$colors[12]; brightPurple=$colors[13]; brightCyan=$colors[14]; brightWhite=$colors[8] }
    $existing = @($settings.schemes | Where-Object { $_.name -ne $p.Scheme })
    $existing += [pscustomobject]$scheme
    $settings.schemes = $existing

    $defaults = $settings.profiles.defaults
    Ensure-Property $defaults 'colorScheme' $p.Scheme
    Ensure-Property $defaults 'font' ([pscustomobject]@{})
    Ensure-Property $defaults.font 'face' $p.Font
    Ensure-Property $defaults.font 'size' $p.Size
    Ensure-Property $defaults 'opacity' $p.Opacity
    Ensure-Property $defaults 'useAcrylic' $p.Acrylic
    Ensure-Property $defaults 'cursorShape' $p.Cursor
    Ensure-Property $defaults 'padding' $p.Padding
    Ensure-Property $defaults 'backgroundImage' (Join-Path $Root $p.Bg)
    Ensure-Property $defaults 'backgroundImageOpacity' 0.22
    Ensure-Property $defaults 'backgroundImageStretchMode' 'uniformToFill'
    Ensure-Property $defaults 'experimental.retroTerminalEffect' $p.Retro
    $json = $settings | ConvertTo-Json -Depth 100
    # Write UTF-8 without BOM, which Windows Terminal accepts reliably
    [System.IO.File]::WriteAllText($path, $json, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "`nТема «$themeName» применена." -ForegroundColor Green
    Write-Host 'Изменены не только цвета: шрифт, размер, прозрачность, отступы, курсор и фон.' -ForegroundColor Gray
    Write-Host 'Если шрифт JetBrainsMono Nerd Font не установлен, выберите «Установить шрифт».' -ForegroundColor Yellow
    Write-Host 'Перезапустите Windows Terminal, чтобы увидеть все изменения.' -ForegroundColor Yellow
}
function Install-Font {
    $url = 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip'
    $tempZip = Join-Path $env:TEMP 'JetBrainsMono-NerdFont.zip'
    $tempDir = Join-Path $env:TEMP 'JetBrainsMono-NerdFont'
    $fontDir = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
    try {
      Write-Host 'Загружаю JetBrainsMono Nerd Font (есть кириллица и латиница)...' -ForegroundColor Cyan
      Invoke-WebRequest -Uri $url -OutFile $tempZip -UseBasicParsing
      if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
      Expand-Archive -LiteralPath $tempZip -DestinationPath $tempDir -Force
      New-Item -ItemType Directory -Path $fontDir -Force | Out-Null
      $installed = 0
      Get-ChildItem $tempDir -Recurse -Include '*.ttf','*.otf' | Where-Object { $_.Name -match 'JetBrainsMonoNerdFont-(Regular|Bold|Italic|BoldItalic)\.' -or $_.Name -match 'JetBrainsMonoNerdFont-Regular\.' } | ForEach-Object {
        $dest = Join-Path $fontDir $_.Name
        Copy-Item $_.FullName $dest -Force
        $regName = $_.BaseName
        New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -Name "$regName (TrueType)" -Value $dest -PropertyType String -Force | Out-Null
        $installed++
      }
      if ($installed -eq 0) { throw 'В архиве не найдены файлы шрифта. Попробуйте установить шрифт вручную.' }
      Write-Host "Шрифт установлен для текущего пользователя (файлов: $installed)." -ForegroundColor Green
      Write-Host 'Закройте все окна Terminal и откройте заново.' -ForegroundColor Yellow
    } catch { Write-Host "Не удалось установить шрифт: $($_.Exception.Message)" -ForegroundColor Red }
}

function Get-DocumentsPath {
    $docs = [Environment]::GetFolderPath('MyDocuments')
    if ([string]::IsNullOrWhiteSpace($docs)) { $docs = Join-Path $HOME 'Documents' }
    return $docs
}
function Ensure-ExecutionPolicy {
    # Profiles will not load under Restricted. CurrentUser RemoteSigned is enough for local scripts.
    try {
      $cu = Get-ExecutionPolicy -Scope CurrentUser -ErrorAction SilentlyContinue
      if ($cu -in @('Restricted', 'Undefined', 'AllSigned', $null)) {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host 'Политика выполнения PowerShell: RemoteSigned (CurrentUser).' -ForegroundColor Green
      }
    } catch {
      Write-Host "Не удалось изменить ExecutionPolicy: $($_.Exception.Message)" -ForegroundColor Yellow
      Write-Host 'Выполните вручную: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser' -ForegroundColor Yellow
    }
    # Also make Windows Terminal start PowerShell with Bypass so the profile always loads.
    try { Ensure-WindowsTerminalPowerShellPolicy } catch {
      Write-Host "Не удалось обновить commandline Windows Terminal: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
function Ensure-WindowsTerminalPowerShellPolicy {
    $path = Find-Settings
    if (-not $path) { return }
    $settings = Read-Settings $path
    if (-not $settings.profiles -or -not $settings.profiles.list) { return }
    $changed = $false
    foreach ($profile in @($settings.profiles.list)) {
      $name = [string]$profile.name
      $cmd = [string]$profile.commandline
      $source = [string]$profile.source
      $isWinPs = ($name -match 'Windows PowerShell') -or ($cmd -match '(?i)(^|[\\/])powershell(\.exe)?(\s|$)') -or ($profile.guid -eq '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}')
      $isPwsh = ($name -match '(?i)^PowerShell$') -or ($cmd -match '(?i)(^|[\\/])pwsh(\.exe)?(\s|$)') -or ($source -match 'Microsoft\.PowerShellCore')
      if (-not ($isWinPs -or $isPwsh)) { continue }

      if ([string]::IsNullOrWhiteSpace($cmd)) {
        $cmd = if ($isPwsh) { 'pwsh.exe' } else { 'powershell.exe' }
      }
      if ($cmd -notmatch '(?i)-ExecutionPolicy\s+\S+') {
        if ($cmd -match '(?i)^(.*?powershell\.exe|.*?pwsh\.exe|[^\s]+)(.*)$') {
          $exePart = $Matches[1]
          $rest = $Matches[2]
          $cmd = "$exePart -NoLogo -ExecutionPolicy Bypass$rest".Trim()
        } else {
          $cmd = "$cmd -NoLogo -ExecutionPolicy Bypass"
        }
        Ensure-Property $profile 'commandline' $cmd
        $changed = $true
      }
    }
    if ($changed) {
      $backup = "$path.terminal-customizer-backup"
      if (-not (Test-Path -LiteralPath $backup)) { Copy-Item -LiteralPath $path -Destination $backup }
      $json = $settings | ConvertTo-Json -Depth 100
      [System.IO.File]::WriteAllText($path, $json, (New-Object System.Text.UTF8Encoding($false)))
      Write-Host 'Windows Terminal: для PowerShell добавлен -ExecutionPolicy Bypass.' -ForegroundColor Green
    }
}
function Find-OhMyPosh {
    $cmd = Get-Command 'oh-my-posh.exe' -ErrorAction SilentlyContinue
    if (-not $cmd) { $cmd = Get-Command 'oh-my-posh' -ErrorAction SilentlyContinue }
    if ($cmd) {
        # WindowsApps execution alias is a 0-byte reparse point; prefer real MSIX exe when present.
        $src = $cmd.Source
        if ($src -and (Test-Path -LiteralPath $src)) {
            try {
                $item = Get-Item -LiteralPath $src -Force -ErrorAction Stop
                if ($item.Length -gt 0) { return $src }
            } catch { }
        }
    }
    $pkg = Get-AppxPackage -Name 'ohmyposh.cli' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($pkg -and $pkg.InstallLocation) {
        $msixExe = Join-Path $pkg.InstallLocation 'oh-my-posh.exe'
        if (Test-Path -LiteralPath $msixExe) { return $msixExe }
    }
    $candidates = @(
      (Join-Path $env:LOCALAPPDATA 'Programs\oh-my-posh\bin\oh-my-posh.exe'),
      (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\oh-my-posh.exe'),
      (Join-Path $env:ProgramFiles 'oh-my-posh\bin\oh-my-posh.exe')
    )
    foreach ($candidate in $candidates) { if ($candidate -and (Test-Path -LiteralPath $candidate)) { return $candidate } }
    # Fall back to PATH alias (works interactively even when Length is 0)
    if ($cmd) { return $cmd.Source }
    return $null
}
function Install-OhMyPosh {
    $exe = Find-OhMyPosh
    if ($exe) {
      Write-Host 'Oh My Posh уже установлен.' -ForegroundColor Green
      $upgrade = Read-Host 'Обновить его через winget? (Д/н)'
      if ($upgrade -match '^(н|no|n)$') { return }
      $wingetArgs = @('upgrade','--id','JanDeDobbeleer.OhMyPosh','--source','winget','--accept-source-agreements','--accept-package-agreements')
    } else {
      $wingetArgs = @('install','--id','JanDeDobbeleer.OhMyPosh','--source','winget','--accept-source-agreements','--accept-package-agreements')
    }
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
      Write-Host 'Не найден winget. Установите App Installer из Microsoft Store и повторите.' -ForegroundColor Red
      return
    }
    Write-Host 'Запускаю установку/обновление Oh My Posh...' -ForegroundColor Cyan
    & winget.exe @wingetArgs
    $wingetExitCode = $LASTEXITCODE
    if ($wingetExitCode -eq 0) {
      Write-Host 'Готово. Если программа не найдена сразу, закройте и откройте Terminal.' -ForegroundColor Green
    }
    elseif ($wingetExitCode -eq -1978335189 -and $exe) {
      # 0x8A15002B / APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE:
      # Oh My Posh is installed, but winget has no newer applicable version.
      Write-Host 'Обновление не требуется: Oh My Posh уже установлен и доступная версия актуальна.' -ForegroundColor Green
    }
    else {
      Write-Host "winget завершился с кодом $wingetExitCode." -ForegroundColor Red
      Write-Host 'Проверьте подключение к интернету и источники winget. Подробности: winget error' -ForegroundColor Yellow
    }
}
function Find-PoshThemes([string]$exe) {
    $paths = @()
    if ($env:POSH_THEMES_PATH) { $paths += $env:POSH_THEMES_PATH }
    # MSIX / Microsoft Store install: themes live next to the real package exe
    $pkg = Get-AppxPackage -Name 'ohmyposh.cli' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($pkg -and $pkg.InstallLocation) {
      $paths += (Join-Path $pkg.InstallLocation 'themes')
    }
    if ($exe) {
      $binDir = Split-Path -Parent $exe
      $paths += (Join-Path $binDir 'themes')
      $paths += (Join-Path (Split-Path -Parent $binDir) 'themes')
    }
    $paths += (Join-Path $env:LOCALAPPDATA 'Programs\oh-my-posh\themes')
    $paths += (Join-Path $env:ProgramFiles 'oh-my-posh\themes')
    foreach ($dir in ($paths | Select-Object -Unique)) {
      if ($dir -and (Test-Path -LiteralPath $dir)) {
        $files = @(Get-ChildItem -LiteralPath $dir -Filter '*.omp.json' -File -ErrorAction SilentlyContinue)
        if ($files.Count -eq 0) {
          $files = @(Get-ChildItem -LiteralPath $dir -Filter '*.omp.yaml' -File -ErrorAction SilentlyContinue)
        }
        if ($files.Count -gt 0) { return $files }
      }
    }
    return @()
}
function Get-PowerShellProfiles {
    $docs = Get-DocumentsPath
    $list = @(
      [pscustomobject]@{ Path = (Join-Path $docs 'WindowsPowerShell\Microsoft.PowerShell_profile.ps1'); Shell = 'powershell' },
      [pscustomobject]@{ Path = (Join-Path $docs 'PowerShell\Microsoft.PowerShell_profile.ps1'); Shell = 'pwsh' }
    )
    # Also honor current-host $PROFILE when it differs (rare custom hosts)
    if ($PROFILE -and ($list.Path -notcontains $PROFILE)) {
      $shell = if ($PSVersionTable.PSEdition -eq 'Core') { 'pwsh' } else { 'powershell' }
      $list += [pscustomobject]@{ Path = $PROFILE; Shell = $shell }
    }
    $seen = @{}
    $result = @()
    foreach ($item in $list) {
      if (-not $seen.ContainsKey($item.Path)) {
        $seen[$item.Path] = $true
        $result += $item
      }
    }
    return $result
}
function Set-PoshTheme([System.IO.FileInfo]$themeFile, [string]$exe) {
    Ensure-ExecutionPolicy

    $themeName = ($themeFile.BaseName -replace '\.omp$','')
    # Prefer theme name for MSIX (no POSH_THEMES_PATH); keep absolute path as reliable offline fallback.
    $themePath = $themeFile.FullName.Replace('\','/')
    $useName = $false
    try {
      $pkg = Get-AppxPackage -Name 'ohmyposh.cli' -ErrorAction SilentlyContinue | Select-Object -First 1
      if ($pkg -and $themeFile.FullName.StartsWith($pkg.InstallLocation, [System.StringComparison]::OrdinalIgnoreCase)) {
        $useName = $true
      }
    } catch { }
    $configArg = if ($useName) { $themeName } else { $themePath }

    # Stable cache outside AppData avoids MSIX virtualized FS issues with init scripts
    $ompCache = Join-Path $HOME '.omp-cache'
    New-Item -ItemType Directory -Path $ompCache -Force | Out-Null

    $profiles = @(Get-PowerShellProfiles)
    $blockStart = '# >>> Windows Terminal Customizer: Oh My Posh >>>'
    $blockEnd = '# <<< Windows Terminal Customizer: Oh My Posh <<<'
    foreach ($profileInfo in $profiles) {
      $profilePath = $profileInfo.Path
      $shell = $profileInfo.Shell
      $parent = Split-Path -Parent $profilePath
      New-Item -ItemType Directory -Path $parent -Force | Out-Null
      if (Test-Path -LiteralPath $profilePath) {
        $content = Get-Content -LiteralPath $profilePath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if ($null -eq $content) { $content = '' }
        $backup = "$profilePath.terminal-customizer-backup"
        if (-not (Test-Path -LiteralPath $backup)) { Copy-Item -LiteralPath $profilePath -Destination $backup }
        $escapedStart = [regex]::Escape($blockStart)
        $escapedEnd = [regex]::Escape($blockEnd)
        $content = [regex]::Replace($content, "(?ms)^$escapedStart\r?\n.*?^$escapedEnd\r?\n?", '')
        $content = [regex]::Replace($content, '(?m)^\s*oh-my-posh init (pwsh|powershell) .*\|\s*Invoke-Expression\s*\r?\n?', '')
      } else { $content = '' }
      $lines = @(
        $blockStart
        "`$env:OMP_CACHE_DIR = '$($ompCache.Replace('\','/'))'"
        "oh-my-posh init $shell --config `"$configArg`" | Invoke-Expression"
        $blockEnd
      )
      $newContent = $content.TrimEnd() + "`r`n`r`n" + ($lines -join "`r`n") + "`r`n"
      [System.IO.File]::WriteAllText($profilePath, $newContent, (New-Object System.Text.UTF8Encoding($false)))
      try { Unblock-File -LiteralPath $profilePath -ErrorAction SilentlyContinue } catch { }
      Write-Host "  Профиль обновлён: $profilePath" -ForegroundColor Gray
    }
    Write-Host "Тема Oh My Posh «$themeName» назначена для PowerShell." -ForegroundColor Green
    Write-Host 'Профили PowerShell сохранены; резервные копии созданы рядом с ними.' -ForegroundColor Gray
    Write-Host 'Полностью закройте Windows Terminal и откройте снова (новая вкладка обязательна).' -ForegroundColor Yellow
}
function Choose-PoshTheme {
    $exe = Find-OhMyPosh
    if (-not $exe) {
      Write-Host 'Oh My Posh не установлен.' -ForegroundColor Yellow
      $answer = Read-Host 'Установить его сейчас? (Д/н)'
      if ($answer -notmatch '^(н|no|n)$') { Install-OhMyPosh }
      $exe = Find-OhMyPosh
    }
    if (-not $exe) {
      Write-Host 'Не удалось найти Oh My Posh. Перезапустите Terminal после установки и повторите.' -ForegroundColor Red
      return
    }
    $themes = @(Find-PoshThemes $exe | Sort-Object Name)
    if ($themes.Count -eq 0) {
      Write-Host 'Не удалось найти локальные файлы тем Oh My Posh.' -ForegroundColor Red
      Write-Host 'Для установки через Microsoft Store/winget (MSIX) темы лежат внутри пакета.' -ForegroundColor Yellow
      Write-Host 'Попробуйте пункт «Установить или обновить Oh My Posh», затем повторите.' -ForegroundColor Yellow
      Write-Host 'Каталог тем: https://ohmyposh.dev/docs/themes' -ForegroundColor DarkGray
      return
    }
    while ($true) {
      Clear-Host
      Write-Host '  OH MY POSH — ТЕМЫ ПРИГЛАШЕНИЯ КОМАНДНОЙ СТРОКИ' -ForegroundColor Cyan
      Write-Host "  Найдено тем: $($themes.Count). Можно ввести номер или поиск по названию." -ForegroundColor Gray
      Write-Host '  0. Назад' -ForegroundColor DarkGray
      $query = Read-Host "`n  Поиск темы (Enter — показать список)"
      if ($query -eq '0') { return }
      $filtered = if ([string]::IsNullOrWhiteSpace($query)) { $themes } else { @($themes | Where-Object { $_.BaseName -like "*$query*" }) }
      if ($filtered.Count -eq 0) { Write-Host 'Ничего не найдено.' -ForegroundColor Yellow; Start-Sleep -Seconds 1; continue }
      $pageSize = 20
      $page = 0
      while ($true) {
        Clear-Host
        Write-Host "  ТЕМЫ OH MY POSH — страница $($page+1) из $([math]::Ceiling($filtered.Count/$pageSize))" -ForegroundColor Cyan
        $start = $page * $pageSize
        $end = [Math]::Min($start + $pageSize - 1, $filtered.Count - 1)
        for ($i=$start; $i -le $end; $i++) { Write-Host ('  {0,3}. {1}' -f ($i+1), ($filtered[$i].BaseName -replace '\.omp$','')) }
        Write-Host ''; Write-Host '  N — следующая страница | P — предыдущая | S — новый поиск | 0 — назад' -ForegroundColor DarkGray
        $selection = Read-Host '  Номер темы или команда'
        if ($selection -eq '0') { break }
        if ($selection -match '^(n|N)$') { if (($page+1)*$pageSize -lt $filtered.Count) { $page++ }; continue }
        if ($selection -match '^(p|P)$') { if ($page -gt 0) { $page-- }; continue }
        if ($selection -match '^(s|S)$') { break }
        $num = 0
        if ([int]::TryParse($selection, [ref]$num) -and $num -ge 1 -and $num -le $filtered.Count) {
          try { Set-PoshTheme $filtered[$num-1] $exe } catch { Write-Host "Ошибка настройки темы: $($_.Exception.Message)" -ForegroundColor Red }
          Read-Host 'Нажмите Enter для возврата' | Out-Null
          return
        }
        Write-Host 'Введите номер из списка или N/P/S/0.' -ForegroundColor Yellow; Start-Sleep -Milliseconds 900
      }
      if ($selection -match '^(s|S)$') { continue }
    }
}

function Reset-Settings {
    $path = Find-Settings
    if (-not $path) { Write-Host 'Не найден settings.json.' -ForegroundColor Red; return }
    $backup = "$path.terminal-customizer-backup"
    if (Test-Path -LiteralPath $backup) {
      Copy-Item -LiteralPath $backup -Destination $path -Force
      Write-Host 'Исходные настройки восстановлены из резервной копии.' -ForegroundColor Green
    } else {
      Write-Host 'Резервной копии нет. Настройки не изменены.' -ForegroundColor Yellow
    }
}
while ($true) {
    Write-Title
    Write-Host '  ВЫБЕРИТЕ ДЕЙСТВИЕ' -ForegroundColor White
    Write-Host '  1. Установить кастомную тему Windows Terminal'
    Write-Host '  2. Установить шрифт JetBrainsMono Nerd Font (кириллица + латиница)'
    Write-Host '  3. Выбрать тему Oh My Posh (оформление командной строки)'
    Write-Host '  4. Установить или обновить Oh My Posh'
    Write-Host '  5. Восстановить исходные настройки Windows Terminal'
    Write-Host '  6. Выход'
    Write-Host ''
    $action = Read-Host '  Ваш выбор'
    switch ($action) {
      '1' {
        Write-Title
        Write-Host '  КАСТОМНЫЕ ТЕМЫ WINDOWS TERMINAL' -ForegroundColor White
        Write-Host '  1. Cyberpunk  — неон, фон, прозрачность, курсор'
        Write-Host '  2. Dracula    — фиолетовая, мягкая прозрачность'
        Write-Host '  3. Nord       — холодная северная палитра, чистый вид'
        Write-Host '  4. Tokyo Night — ночной фон и мягкие оттенки'
        Write-Host '  5. Matrix     — зелёный терминал с ретро-эффектом'
        Write-Host '  6. Gruvbox    — тёплый ретро-стиль'
        Write-Host '  7. Ocean      — сине-бирюзовый стиль'
        Write-Host '  8. Solarized  — спокойная классическая тема'
        Write-Host '  9. Назад'
        $choice = Read-Host "`n  Номер темы"
        $map = @{ '1'='Cyberpunk'; '2'='Dracula'; '3'='Nord'; '4'='TokyoNight'; '5'='Matrix'; '6'='Gruvbox'; '7'='Ocean'; '8'='Solarized' }
        if ($map.ContainsKey($choice)) { try { Set-Theme $map[$choice] } catch { Write-Host "Ошибка применения темы: $($_.Exception.Message)" -ForegroundColor Red } }
        Read-Host 'Нажмите Enter для возврата в меню' | Out-Null
      }
      '2' { Install-Font; Read-Host 'Нажмите Enter для возврата в меню' | Out-Null }
      '3' { Choose-PoshTheme; Read-Host 'Нажмите Enter для возврата в меню' | Out-Null }
      '4' { Install-OhMyPosh; Read-Host 'Нажмите Enter для возврата в меню' | Out-Null }
      '5' { Reset-Settings; Read-Host 'Нажмите Enter для возврата в меню' | Out-Null }
      '6' { break }
      default { Write-Host 'Введите число от 1 до 6.' -ForegroundColor Yellow; Start-Sleep -Seconds 1 }
    }
    if ($action -eq '6') { break }
}
