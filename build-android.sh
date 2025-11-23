#!/bin/bash
# Android APK Build Script for SNS User Management System
# このスクリプトはAndroid APKをビルドします

set -e

echo "========================================="
echo "SNSユーザ管理システム - Android APKビルド"
echo "========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "エラー: このスクリプトはプロジェクトのルートディレクトリで実行してください"
    exit 1
fi

echo "📱 Android APKのビルドを開始します..."
echo ""

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js が見つかりません"
    echo "   Node.js 14以上をインストールしてください"
    echo "   https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "✅ Node.js が見つかりました: $NODE_VERSION"

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm が見つかりません"
    exit 1
fi

echo "✅ npm が見つかりました"

# Install dependencies
echo ""
echo "📦 依存関係をインストール中..."
npm install

# Check for Cordova
if ! command -v cordova &> /dev/null; then
    echo ""
    echo "📦 Cordova をインストール中..."
    npm install -g cordova
fi

echo "✅ Cordova が利用可能です"

# Check for Java (required for Android build)
if ! command -v java &> /dev/null; then
    echo ""
    echo "⚠️  Java が見つかりません（Android APKビルドに必要）"
    echo "   JDK 11以上をインストールしてください"
    echo "   https://adoptium.net/"
fi

# Check for Android SDK
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo ""
    echo "⚠️  Android SDK が設定されていません"
    echo "   Android Studio をインストールし、環境変数を設定してください:"
    echo "   export ANDROID_HOME=/path/to/Android/sdk"
    echo "   export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
fi

# Add Android platform if not already added
echo ""
echo "🤖 Android プラットフォームを準備中..."
if [ ! -d "platforms/android" ]; then
    cordova platform add android
    echo "✅ Android プラットフォームを追加しました"
else
    echo "✅ Android プラットフォームは既に追加されています"
fi

# Build APK
echo ""
echo "🔨 APKをビルド中..."
echo "   これには数分かかる場合があります..."
cordova build android

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "✅ APKビルド成功！"
    echo "========================================="
    echo ""
    echo "📦 APKファイルの場所:"
    echo ""
    echo "デバッグ版:"
    echo "  platforms/android/app/build/outputs/apk/debug/app-debug.apk"
    echo ""
    echo "このAPKをAndroidデバイスにインストールできます。"
    echo ""
    echo "リリース版のビルド方法:"
    echo "  ./build-android.sh --release"
    echo ""
else
    echo ""
    echo "❌ ビルドに失敗しました"
    echo "   エラーメッセージを確認して、必要な依存関係をインストールしてください"
    exit 1
fi

echo "========================================="
