# SNS ユーザ管理システム

クロスプラットフォームのSNSユーザ管理システムです。主要SNSプラットフォーム（Twitter開始）でのユーザー情報、フォロー関係、興味・関心、投稿などを一元管理します。

## 📥 ダウンロードとインストール

### 💾 ダウンロード方法

**方法1: ZIPファイルをダウンロード（推奨）**

<a href="https://github.com/ymtezo/sns-users-management/archive/refs/heads/copilot/add-user-management-for-sns.zip" style="display:inline-block;padding:10px 20px;background:#28a745;color:white;text-decoration:none;border-radius:5px;font-weight:bold;">📦 ZIPをダウンロード</a>

または GitHubページで:
1. 緑色の「Code」ボタンをクリック
2. 「Download ZIP」を選択
3. ダウンロードしたZIPファイルを解凍

**方法2: Gitでクローン**

```bash
git clone https://github.com/ymtezo/sns-users-management.git
cd sns-users-management
```

### クイックスタート

**最も簡単な方法（フロントエンド版）:**

1. **ダウンロード:**
   - [ZIPファイルをダウンロード](https://github.com/ymtezo/sns-users-management/archive/refs/heads/copilot/add-user-management-for-sns.zip)
   - または GitHubページの「Code」→「Download ZIP」

2. **解凍して起動:**
   ```bash
   # ZIPを解凍後、フォルダ内で
   # ブラウザで index.html を開く（ダブルクリック）
   ```

**自動セットアップ（Linux/Mac）:**

```bash
# ダウンロード・解凍後
cd sns-users-management
chmod +x setup.sh
./setup.sh
```

詳細な手順は [QUICKSTART.md](QUICKSTART.md) をご覧ください。

### 📱 Android APK版（新機能）

**Android アプリとしてビルド:**

```bash
# Linux/Mac
./build-android.sh

# Windows  
build-android.bat
```

ビルドされたAPKは以下に出力されます:
- `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

詳細な手順とトラブルシューティング: [ANDROID_BUILD.md](ANDROID_BUILD.md)

**必要な環境:**
- Node.js 14+
- Java JDK 11+
- Android SDK (Android Studioを推奨)

## プロジェクト構成

このリポジトリには2つの実装が含まれています：

### 1. フロントエンド版（HTML/CSS/JavaScript）
- ブラウザで直接実行可能なシングルページアプリケーション
- LocalStorageを使用したデータ永続化
- Twitter風のモダンなUI
- **Android APKとしてパッケージ化可能** 🆕

### 2. Ruby API版（Sinatra）
- RESTful JSON API
- SQLite3データベース + ActiveRecord ORM  
- Notion Database連携版も提供
- 詳細は [README_RUBY.md](README_RUBY.md) を参照

## 機能

### 実装済み機能

- ✅ **ユーザー管理**
  - ユーザーの追加・削除
  - プロフィール情報の管理（ユーザー名、表示名、プロフィール文）
  
- ✅ **興味・関心の管理**
  - 興味のタグ付け
  - 興味の詳細情報（どういった点で興味があるか）
  
- ✅ **属性管理**
  - ユーザーの属性タグ（エンジニア、デザイナーなど）
  
- ✅ **フォロー関係の管理**
  - フォロー/フォロワー関係の追加
  - フォロー数・フォロワー数の表示
  
- ✅ **投稿といいねの管理**
  - 主要な投稿の表示
  - いいね数の表示
  
- ✅ **HTMLレンダリング**
  - ユーザーカードの視覚的表示
  - 投稿、いいね、属性の紐付け表示
  
- ✅ **プラットフォーム対応**
  - Twitter対応（実装済み）
  - Instagram、Facebook（準備中）

### データモデル

#### User（ユーザー）
```javascript
{
  id: String,              // ユニークID
  platform: String,        // プラットフォーム（twitter, instagram, etc.）
  username: String,        // ユーザー名（@username）
  displayName: String,     // 表示名
  bio: String,            // プロフィール文
  interests: [String],    // 興味・関心のリスト
  interestDetails: String, // 興味の詳細（どういった点で興味があるか）
  attributes: [String],   // 属性のリスト
  createdAt: String       // 作成日時
}
```

#### Relationship（フォロー関係）
```javascript
{
  follower: String,   // フォローするユーザーのID
  following: String,  // フォローされるユーザーのID
  createdAt: String  // 作成日時
}
```

#### Post（投稿）
```javascript
{
  id: String,        // ユニークID
  userId: String,    // 投稿者のユーザーID
  content: String,   // 投稿内容
  likes: Number,     // いいね数
  createdAt: String  // 作成日時
}
```

## 使い方

### フロントエンド版

### 起動方法

1. リポジトリをクローン
```bash
git clone https://github.com/ymtezo/sns-users-management.git
cd sns-users-management
```

2. ブラウザで `index.html` を開く
```bash
# シンプルなHTTPサーバーで起動する場合
python -m http.server 8000
# または
npx http-server
```

3. ブラウザで `http://localhost:8000` にアクセス

### Ruby API版

詳細なドキュメントは [README_RUBY.md](README_RUBY.md) を参照してください。

```bash
# 依存関係のインストール
bundle install

# データベースのセットアップ
bundle exec ruby db/migrate.rb

# サーバー起動（SQLite版）
bundle exec ruby app.rb -p 4567

# または Notion連携版
export NOTION_API_KEY=your_key
export NOTION_DATABASE_ID=your_db_id
bundle exec ruby app_notion.rb -p 4568
```

API エンドポイント例:
- `GET /api/users` - ユーザー一覧取得
- `POST /api/users` - ユーザー作成
- `GET /api/users/:id` - ユーザー詳細取得
- `PUT /api/users/:id` - ユーザー更新
- `DELETE /api/users/:id` - ユーザー削除

### 基本的な使い方（フロントエンド版）

1. **ユーザーを追加する**
   - 「ユーザー追加」セクションでフォームに入力
   - ユーザー名、表示名は必須
   - 興味・関心、属性はカンマ区切りで複数入力可能
   - 「ユーザー追加」ボタンをクリック

2. **フォロー関係を設定する**
   - 「フォロー関係の設定」セクションで2人のユーザーを選択
   - 「フォロー関係を追加」ボタンをクリック

3. **ユーザー情報を確認する**
   - 「登録ユーザー一覧」でカード形式で表示
   - フォロー数、フォロワー数が自動計算される
   - 主要な投稿といいね数が表示される

## 技術スタック

### フロントエンド版
- **フロントエンド**: HTML5, CSS3, Vanilla JavaScript
- **データ保存**: LocalStorage (ブラウザ内ストレージ)
- **スタイリング**: カスタムCSS（Twitter風デザイン）

### Ruby API版
- **フレームワーク**: Sinatra 4.0
- **ORM**: ActiveRecord 7.0
- **データベース**: SQLite3
- **Notion連携**: HTTParty + Notion API
- **CORS**: Rack-CORS

## プロジェクト構造

```
sns-users-management/
├── index.html          # フロントエンドメインHTMLファイル
├── styles.css          # フロントエンドスタイルシート
├── app.js             # フロントエンドアプリケーションロジック
├── config.xml         # Cordova/Android設定 🆕
├── package.json       # Node.js/Cordova依存関係 🆕
├── build-android.sh   # Android APKビルドスクリプト（Linux/Mac）🆕
├── build-android.bat  # Android APKビルドスクリプト（Windows）🆕
├── app.rb             # Ruby API (SQLite版)
├── app_notion.rb      # Ruby API (Notion連携版)
├── config.ru          # Rackup設定
├── Gemfile            # Ruby依存関係
├── db/
│   ├── migrate.rb     # データベースマイグレーション
│   └── sns_users.db   # SQLiteデータベース
├── lib/
│   └── notion_service.rb  # Notion API統合
├── README.md          # このファイル
├── ANDROID_BUILD.md   # Android APKビルドガイド 🆕
└── README_RUBY.md     # Ruby API詳細ドキュメント
```

## 今後の拡張予定

- [ ] Instagram対応
- [ ] Facebook対応  
- [x] Ruby API with CRUD operations
- [x] Notion Database integration
- [x] **Android APK パッケージング** 🆕
- [ ] データのエクスポート/インポート機能
- [ ] 検索・フィルタリング機能
- [ ] グラフ表示（関係性の可視化）
- [ ] フロントエンドとRuby APIの統合
- [ ] 認証・認可機能
- [ ] 実際のSNS APIとの連携
- [ ] iOS版アプリ

## ライセンス

MIT

## 貢献

プルリクエストを歓迎します！