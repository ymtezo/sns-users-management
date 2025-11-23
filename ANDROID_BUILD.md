# Android APK ビルドガイド

このガイドでは、SNSユーザ管理システムをAndroid APKとしてビルドする方法を説明します。

## 📱 APKについて

このプロジェクトは**Apache Cordova**を使用してWeb技術（HTML/CSS/JavaScript）をネイティブAndroidアプリケーションにパッケージ化します。

ビルドされたAPKは以下の機能を含みます:
- フロントエンド版のすべての機能
- オフラインでの動作（LocalStorage使用）
- Androidデバイスにインストール可能
- アプリストアへの配布可能（署名後）

## 🛠 必要な環境

### 必須
1. **Node.js** (v14以上)
   - ダウンロード: https://nodejs.org/
   - 確認: `node --version`

2. **npm** (Node.jsに付属)
   - 確認: `npm --version`

3. **Java Development Kit (JDK)** (v11以上)
   - ダウンロード: https://adoptium.net/
   - 確認: `java -version`

4. **Android SDK** (Android Studioに付属)
   - ダウンロード: https://developer.android.com/studio
   - 環境変数の設定が必要

### 推奨
- **Android Studio** - 最も簡単なセットアップ方法
- **Gradle** (Android Studioに付属)

## 📦 セットアップ手順

### ステップ1: 環境変数の設定

#### Linux/Mac:

```bash
# ~/.bashrc または ~/.zshrc に追加
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# 設定を反映
source ~/.bashrc  # または source ~/.zshrc
```

#### Windows:

1. システムのプロパティ → 環境変数
2. 新規システム変数を追加:
   - 変数名: `ANDROID_HOME`
   - 変数値: `C:\Users\YourName\AppData\Local\Android\Sdk`
3. Path変数に以下を追加:
   - `%ANDROID_HOME%\tools`
   - `%ANDROID_HOME%\platform-tools`
   - `%ANDROID_HOME%\cmdline-tools\latest\bin`

### ステップ2: Android SDKコンポーネントのインストール

Android Studio SDK Managerで以下をインストール:
- Android SDK Platform (API 33推奨)
- Android SDK Build-Tools (最新版)
- Android SDK Platform-Tools
- Android SDK Tools

または、コマンドラインで:

```bash
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
```

### ステップ3: Cordovaのインストール

```bash
npm install -g cordova
```

確認:
```bash
cordova --version
```

## 🚀 APKのビルド

### 自動ビルド（推奨）

#### Linux/Mac:

```bash
# プロジェクトディレクトリで
./build-android.sh
```

#### Windows:

```cmd
build-android.bat
```

### 手動ビルド

```bash
# 1. 依存関係をインストール
npm install

# 2. Androidプラットフォームを追加（初回のみ）
cordova platform add android

# 3. APKをビルド
cordova build android

# デバッグAPKの場所:
# platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 📲 APKのインストール

### 方法1: USBケーブル経由

1. Androidデバイスで「開発者向けオプション」を有効化
2. 「USBデバッグ」を有効化
3. デバイスをコンピュータに接続
4. 以下のコマンドを実行:

```bash
# APKをインストール
adb install platforms/android/app/build/outputs/apk/debug/app-debug.apk

# または、Cordovaコマンドで
cordova run android
```

### 方法2: APKファイルを直接転送

1. ビルドされたAPKファイルをAndroidデバイスに転送
   - `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
2. デバイスで「提供元不明のアプリ」のインストールを許可
3. ファイルマネージャーでAPKを開いてインストール

## 🔐 リリース版APKのビルド

リリース版（署名付き）APKは、Google Playストアなどでの配布に必要です。

### ステップ1: キーストアの作成

```bash
keytool -genkey -v -keystore sns-release-key.keystore \
  -alias sns-release \
  -keyalg RSA -keysize 2048 -validity 10000
```

パスワードとユーザー情報を入力してください。

### ステップ2: build.jsonの作成

プロジェクトルートに `build.json` を作成:

```json
{
  "android": {
    "release": {
      "keystore": "sns-release-key.keystore",
      "storePassword": "your_keystore_password",
      "alias": "sns-release",
      "password": "your_key_password"
    }
  }
}
```

**重要:** `build.json` は `.gitignore` に追加してください（秘密情報を含むため）

### ステップ3: リリースビルド

```bash
cordova build android --release

# リリースAPKの場所:
# platforms/android/app/build/outputs/apk/release/app-release.apk
```

## 🎨 カスタマイズ

### アプリアイコンの変更

アイコン画像を `res/icon/android/` に配置:

- `ldpi.png` - 36x36
- `mdpi.png` - 48x48
- `hdpi.png` - 72x72
- `xhdpi.png` - 96x96
- `xxhdpi.png` - 144x144
- `xxxhdpi.png` - 192x192

### アプリ名の変更

`config.xml` を編集:

```xml
<name>あなたのアプリ名</name>
```

### パッケージIDの変更

```xml
<widget id="com.yourcompany.yourapp" ...>
```

## 🐛 トラブルシューティング

### エラー: ANDROID_HOME is not set

**解決策:** 環境変数を正しく設定してください（上記参照）

### エラー: Failed to find 'ANDROID_HOME' environment variable

**解決策:**
```bash
export ANDROID_HOME=/path/to/Android/Sdk
```

### エラー: license for package Android SDK Build-Tools not accepted

**解決策:**
```bash
cd $ANDROID_HOME/tools/bin
./sdkmanager --licenses
# すべてのライセンスに "y" と入力
```

### エラー: Gradle build failed

**解決策:**
1. Android Studioで一度プロジェクトを開く
2. Gradle同期を実行
3. 再度ビルドを試す

### ビルドが遅い

**解決策:**
- Gradleデーモンを有効化: `~/.gradle/gradle.properties` に `org.gradle.daemon=true`
- メモリを増やす: `org.gradle.jvmargs=-Xmx4096m`

## 📊 APKサイズの最適化

ビルド後のAPKサイズを小さくする方法:

1. **ProGuardを有効化** (`build.json`):
```json
{
  "android": {
    "release": {
      "minifyEnabled": true,
      "shrinkResources": true
    }
  }
}
```

2. **未使用のリソースを削除**

3. **画像を最適化** (PNG → WebP など)

## 🚀 Google Playストアへの公開

1. リリース版APKをビルド
2. Google Play Console (https://play.google.com/console) にアクセス
3. 新しいアプリを作成
4. APKをアップロード
5. ストア掲載情報を入力
6. 審査に提出

## 📚 参考リンク

- Apache Cordova公式: https://cordova.apache.org/
- Android開発者ガイド: https://developer.android.com/
- Cordova Androidプラットフォーム: https://cordova.apache.org/docs/en/latest/guide/platforms/android/

## ✅ チェックリスト

ビルド前の確認事項:

- [ ] Node.js がインストールされている
- [ ] Java JDK がインストールされている  
- [ ] Android SDK がインストールされている
- [ ] ANDROID_HOME 環境変数が設定されている
- [ ] Cordova がインストールされている
- [ ] config.xml が正しく設定されている
- [ ] 必要なアイコン画像が準備されている（オプション）

## 💡 ヒント

- 初回ビルドは依存関係のダウンロードに時間がかかります
- エラーが出た場合は、まず環境変数を確認してください
- Android Studioを使うと環境設定が簡単です
- デバッグ版APKは開発・テスト用、リリース版は配布用です
