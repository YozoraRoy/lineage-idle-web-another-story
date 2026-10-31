@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "PORT=8011"

echo ================================================
echo    放置天堂 - 日出之國   停止伺服器
echo    連接埠: %PORT%
echo ================================================
echo.

set "FOUND="
for /f "tokens=5" %%a in ('netstat -ano ^| findstr /r /c:":%PORT% .*LISTENING"') do (
    set "FOUND=1"
    set "PNAME=unknown"
    for /f "tokens=1" %%n in ('tasklist /fi "PID eq %%a" /nh') do set "PNAME=%%n"
    echo 正在停止 PID %%a ^(!PNAME!^) ...
    taskkill /f /pid %%a >nul 2>nul
    if errorlevel 1 (
        echo    [失敗] 無法停止 PID %%a，可能權限不足。
        echo    請改用管理員身分執行本檔案。
    ) else (
        echo    [完成] 已停止。
    )
)

if not defined FOUND (
    echo 目前沒有程式在連接埠 %PORT% 上執行。
    echo 伺服器可能已經關閉。
)

echo.
pause
endlocal
