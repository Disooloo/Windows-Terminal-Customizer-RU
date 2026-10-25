@echo off
setlocal
chcp 65001 >nul
title Windows Terminal Customizer RU — by Disooloo
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0TerminalCustomizer.ps1"
if errorlevel 1 pause
endlocal
