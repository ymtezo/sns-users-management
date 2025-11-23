@echo off
REM SNS User Management System - Quick Setup Script for Windows
REM このスクリプトはプロジェクトのセットアップを自動化します

echo =========================================
echo SNSユーザ管理システム セットアップ
echo =========================================
echo.

REM Check if we're in the right directory
if not exist "index.html" (
    echo エラー: このスクリプトはプロジェクトのルートディレクトリで実行してください
    pause
    exit /b 1
)

echo セットアップを開始します...
echo.

REM Frontend setup
echo ✓ フロントエンド版の準備完了
echo    - index.html, app.js, styles.css が利用可能です
echo.

REM Check for Ruby
where ruby >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ Ruby が見つかりました
    ruby -v
    
    REM Check for bundler
    where bundle >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo ✓ Bundler が見つかりました
        echo.
        echo Ruby依存関係をインストール中...
        call bundle config set --local path vendor/bundle
        call bundle install
        
        echo.
        echo データベースをセットアップ中...
        call bundle exec ruby db/migrate.rb
        
        echo.
        echo ✓ Ruby API版のセットアップ完了
    ) else (
        echo ⚠ Bundler が見つかりません
        echo    インストールするには: gem install bundler
    )
) else (
    echo ⚠ Ruby が見つかりません（Ruby API版を使用する場合は Ruby 3.2+ が必要です）
)

echo.
echo =========================================
echo セットアップ完了！
echo =========================================
echo.
echo 起動方法:
echo.
echo 【フロントエンド版】
echo   1. index.html をダブルクリックしてブラウザで開く
echo   または
echo   2. python -m http.server 8000
echo      その後 http://localhost:8000 にアクセス
echo.

where ruby >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    where bundle >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo 【Ruby API版 - SQLite】
        echo   bundle exec ruby app.rb -p 4567
        echo   その後 http://localhost:4567/health でテスト
        echo.
        echo 【Ruby API版 - Notion連携】
        echo   1. .env ファイルを作成（.env.example を参考に）
        echo   2. NOTION_API_KEY と NOTION_DATABASE_ID を設定
        echo   3. bundle exec ruby app_notion.rb -p 4568
        echo.
    )
)

echo 詳細なドキュメント:
echo   - README.md - 全体概要
echo   - QUICKSTART.md - クイックスタート
echo   - README_RUBY.md - Ruby API詳細
echo.
echo =========================================

pause
