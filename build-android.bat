@echo off
REM Android APK Build Script for SNS User Management System - Windows
REM このスクリプトはAndroid APKをビルドします

echo =========================================
echo SNSユーザ管理システム - Android APKビルド
echo =========================================
echo.

REM Check if we're in the right directory
if not exist "index.html" (
    echo エラー: このスクリプトはプロジェクトのルートディレクトリで実行してください
    pause
    exit /b 1
)

echo Android APKのビルドを開始します...
echo.

REM Check for Node.js
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js が見つかりません
    echo    Node.js 14以上をインストールしてください
    echo    https://nodejs.org/
    pause
    exit /b 1
)

echo ✓ Node.js が見つかりました
node -v

REM Check for npm
where npm >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ npm が見つかりません
    pause
    exit /b 1
)

echo ✓ npm が見つかりました
echo.

REM Install dependencies
echo 依存関係をインストール中...
call npm install

REM Check for Cordova
where cordova >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Cordova をインストール中...
    call npm install -g cordova
)

echo ✓ Cordova が利用可能です
echo.

REM Check for Java
where java >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ⚠ Java が見つかりません（Android APKビルドに必要）
    echo    JDK 11以上をインストールしてください
    echo    https://adoptium.net/
)

REM Check for Android SDK
if "%ANDROID_HOME%"=="" if "%ANDROID_SDK_ROOT%"=="" (
    echo.
    echo ⚠ Android SDK が設定されていません
    echo    Android Studio をインストールし、環境変数を設定してください
    echo    ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk
)

REM Add Android platform if not already added
echo.
echo Android プラットフォームを準備中...
if not exist "platforms\android" (
    call cordova platform add android
    echo ✓ Android プラットフォームを追加しました
) else (
    echo ✓ Android プラットフォームは既に追加されています
)

REM Build APK
echo.
echo APKをビルド中...
echo これには数分かかる場合があります...
call cordova build android

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =========================================
    echo ✓ APKビルド成功！
    echo =========================================
    echo.
    echo APKファイルの場所:
    echo.
    echo デバッグ版:
    echo   platforms\android\app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo このAPKをAndroidデバイスにインストールできます。
    echo.
) else (
    echo.
    echo ❌ ビルドに失敗しました
    echo    エラーメッセージを確認して、必要な依存関係をインストールしてください
)

echo.
echo =========================================
pause
