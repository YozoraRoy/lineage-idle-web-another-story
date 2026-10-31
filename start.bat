@echo off
setlocal
cd /d "%~dp0"

set "PORT=8011"
set "URL=http://127.0.0.1:%PORT%/"

echo ================================================
echo    放置天堂 - 日出之國   本機啟動器
echo    連接埠: %PORT%
echo ================================================
echo.

rem ---- 尋找 Python（優先 python，其次 py 啟動器）----
set "PY="
where python >nul 2>nul
if not errorlevel 1 set "PY=python"
if not defined PY (
    where py >nul 2>nul
    if not errorlevel 1 set "PY=py"
)
if not defined PY (
    echo [錯誤] 找不到 Python，請先安裝 Python 3 並勾選 Add Python to PATH。
    echo        下載: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

rem ---- 檢查連接埠是否已被佔用 ----
netstat -ano | findstr /r /c:":%PORT% .*LISTENING" >nul
if not errorlevel 1 (
    echo [錯誤] 連接埠 %PORT% 已被其他程式佔用。
    echo        請關閉佔用該埠的程式，或修改本檔案的 PORT 設定。
    echo.
    pause
    exit /b 1
)

rem ---- 確認目前資料夾有 index.html ----
if not exist "index.html" (
    echo [錯誤] 目前資料夾找不到 index.html。
    echo        請將 start.bat 放在專案根目錄，與 index.html 同層。
    echo.
    pause
    exit /b 1
)

rem ---- 背景延遲 3 秒後自動開啟瀏覽器（等伺服器就緒）----
start "" /min powershell -NoProfile -WindowStyle Hidden -Command "Start-Sleep -Seconds 3; Start-Process '%URL%'"

echo 伺服器啟動中... 瀏覽器稍後會自動開啟。
echo 若沒自動開啟，請手動前往: %URL%
echo.
echo ※ 關閉此視窗或按 Ctrl+C 即可停止伺服器。
echo.

"%PY%" -m http.server %PORT% --bind 127.0.0.1

echo.
echo 伺服器已停止。
pause
endlocal
