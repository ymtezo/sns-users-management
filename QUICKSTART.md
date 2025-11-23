# SNS User Management System - Quick Start Guide

このガイドでは、SNSユーザ管理システムをダウンロードして使い始める方法を説明します。

## ダウンロード方法

### 方法1: GitHubからダウンロード（推奨）

1. **ZIPファイルをダウンロード**
   - GitHubリポジトリページ: https://github.com/ymtezo/sns-users-management
   - 緑色の「Code」ボタンをクリック
   - 「Download ZIP」を選択
   - ダウンロードしたZIPファイルを解凍

2. **または Git でクローン**
   ```bash
   git clone https://github.com/ymtezo/sns-users-management.git
   cd sns-users-management
   ```

### 方法2: リリースページからダウンロード

- リリースページ: https://github.com/ymtezo/sns-users-management/releases
- 最新リリースのアセットをダウンロード

## クイックスタート

### 🖥️ フロントエンド版（最も簡単）

**必要なもの:** Webブラウザのみ

**手順:**

1. ダウンロードしたフォルダを開く
2. `index.html` をダブルクリックしてブラウザで開く
3. すぐに使い始められます！

**または、ローカルサーバーで実行:**

```bash
# Pythonがインストールされている場合
python -m http.server 8000

# Node.jsがインストールされている場合
npx http-server

# その後、ブラウザで http://localhost:8000 を開く
```

### 📱 Android APK版（新機能！）

**必要なもの:** Node.js 14+, Java JDK 11+, Android SDK

**手順:**

```bash
# Linux/Mac
./build-android.sh

# Windows
build-android.bat
```

ビルドされたAPK: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

**詳細:** [ANDROID_BUILD.md](ANDROID_BUILD.md) を参照

### 🔧 自動セットアップスクリプト（Linux/Mac）

**必要なもの:** Ruby 3.2+ (Ruby API版を使う場合)

```bash
# プロジェクトディレクトリに移動
cd sns-users-management

# セットアップスクリプトを実行可能にする
chmod +x setup.sh

# セットアップスクリプトを実行
./setup.sh
```

このスクリプトは以下を自動的に行います:
- Ruby依存関係のインストール（Rubyがある場合）
- データベースのセットアップ
- 起動方法の表示

### 💎 Ruby API版（手動セットアップ）

**必要なもの:** Ruby 3.2+, Bundler

**SQLite版:**

```bash
# 1. 依存関係をインストール
bundle config set --local path 'vendor/bundle'
bundle install

# 2. データベースをセットアップ
bundle exec ruby db/migrate.rb

# 3. サーバーを起動
bundle exec ruby app.rb -p 4567

# 4. ブラウザで http://localhost:4567/health を開いてテスト
```

**Notion Database連携版:**

```bash
# 1. 環境変数ファイルを作成
cp .env.example .env

# 2. .env ファイルを編集してAPIキーを設定
# NOTION_API_KEY=your_actual_api_key
# NOTION_DATABASE_ID=your_actual_database_id

# 3. 環境変数を読み込む
export $(cat .env | xargs)

# 4. サーバーを起動
bundle exec ruby app_notion.rb -p 4568

# 5. ブラウザで http://localhost:4568/health を開いてテスト
```

## 使い方

### フロントエンド版の使い方

1. **ユーザーを追加**
   - 「ユーザー追加」セクションにユーザー情報を入力
   - 興味・関心、属性はカンマ区切りで入力
   - 「ユーザー追加」ボタンをクリック

2. **フォロー関係を設定**
   - 「フォロー関係の設定」で2人のユーザーを選択
   - 「フォロー関係を追加」ボタンをクリック

3. **データは自動保存**
   - ブラウザのLocalStorageに保存されます
   - ブラウザを閉じても データは保持されます

### Ruby API版の使い方

**APIエンドポイント例:**

```bash
# ユーザー一覧を取得
curl http://localhost:4567/api/users

# ユーザーを作成
curl -X POST http://localhost:4567/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "test_user",
    "display_name": "テストユーザー",
    "platform": "twitter",
    "interests": ["Ruby", "API"],
    "attributes": ["エンジニア"]
  }'

# フォロー関係を作成
curl -X POST http://localhost:4567/api/relationships \
  -H "Content-Type: application/json" \
  -d '{"follower_id": 1, "following_id": 2}'
```

詳細なAPI仕様は `README_RUBY.md` を参照してください。

## トラブルシューティング

### フロントエンド版

**問題:** ブラウザでindex.htmlを開いたが動作しない

**解決策:**
- モダンなブラウザ（Chrome, Firefox, Edge, Safari最新版）を使用してください
- ブラウザのコンソールを開いてエラーを確認してください（F12キー）

### Ruby API版

**問題:** `bundle: command not found`

**解決策:**
```bash
gem install bundler
```

**問題:** `ruby: command not found`

**解決策:**
- Ruby 3.2以上をインストールしてください
- https://www.ruby-lang.org/ja/downloads/

**問題:** データベースエラー

**解決策:**
```bash
# データベースをリセット
rm db/sns_users.db
bundle exec ruby db/migrate.rb
```

**問題:** ポートが既に使用されている

**解決策:**
```bash
# 別のポートを使用
bundle exec ruby app.rb -p 4568
```

## 必要なシステム要件

### フロントエンド版
- モダンなWebブラウザ（Chrome 90+, Firefox 88+, Safari 14+, Edge 90+）
- 特別なソフトウェアは不要

### Ruby API版
- Ruby 3.2以上
- Bundler
- SQLite3（通常Rubyと一緒にインストールされます）

### Notion連携版（追加）
- Notion アカウント
- Notion Integration（APIキー）
- Notion Database

## 次のステップ

1. **基本的な使い方を学ぶ:** `README.md` を読む
2. **Ruby APIを探索:** `README_RUBY.md` を読む
3. **実装詳細を理解:** `IMPLEMENTATION.md` を読む
4. **Notion連携を設定:** `.env.example` を参考に環境変数を設定

## サポート

問題が発生した場合:
- GitHubのIssuesページで質問や報告をしてください
- ドキュメントを確認してください

## ライセンス

MIT License - 自由に使用、修正、配布できます
