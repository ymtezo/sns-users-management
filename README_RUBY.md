# Ruby on Rails SNS User Management API

このディレクトリには、Ruby（Sinatra）で実装されたSNSユーザ管理APIが含まれています。

## 概要

- **フレームワーク**: Sinatra (軽量Ruby Webフレームワーク)
- **データベース**: SQLite3 + ActiveRecord ORM
- **API形式**: RESTful JSON API
- **Notion連携**: Notion Database API統合

## ディレクトリ構造

```
.
├── app.rb                  # メインAPIアプリケーション (SQLite版)
├── app_notion.rb           # Notion Database連携版API
├── config.ru               # Rackupファイル
├── Gemfile                 # Ruby依存関係
├── Gemfile.lock            # ロックされた依存関係
├── db/
│   ├── migrate.rb          # データベースマイグレーション
│   └── sns_users.db        # SQLiteデータベースファイル
├── lib/
│   └── notion_service.rb   # Notion API統合サービス
└── README_RUBY.md          # このファイル
```

## セットアップ

### 1. 依存関係のインストール

```bash
bundle install
```

### 2. データベースのセットアップ

```bash
bundle exec ruby db/migrate.rb
```

### 3. サーバーの起動

#### SQLite版（ローカルデータベース）

```bash
bundle exec ruby app.rb -p 4567
```

#### Notion Database連携版

1. 環境変数を設定:

```bash
cp .env.example .env
# .envファイルを編集してNotion APIキーとDatabase IDを設定
```

2. サーバー起動:

```bash
export NOTION_API_KEY=your_api_key
export NOTION_DATABASE_ID=your_database_id
bundle exec ruby app_notion.rb -p 4568
```

## API エンドポイント

### SQLite版 API (`app.rb`)

#### ユーザー管理

**すべてのユーザーを取得**
```
GET /api/users?platform=twitter
```

**特定のユーザーを取得**
```
GET /api/users/:id
```

**ユーザーを作成**
```
POST /api/users
Content-Type: application/json

{
  "username": "user123",
  "display_name": "User Name",
  "platform": "twitter",
  "bio": "Bio text",
  "interests": ["興味1", "興味2"],
  "interest_details": "詳細な興味の説明",
  "attributes": ["属性1", "属性2"]
}
```

**ユーザーを更新**
```
PUT /api/users/:id
Content-Type: application/json

{
  "display_name": "Updated Name",
  "bio": "Updated bio"
}
```

**ユーザーを削除**
```
DELETE /api/users/:id
```

#### フォロー関係

**すべてのフォロー関係を取得**
```
GET /api/relationships
```

**フォロー関係を作成**
```
POST /api/relationships
Content-Type: application/json

{
  "follower_id": 1,
  "following_id": 2
}
```

**フォロー関係を削除**
```
DELETE /api/relationships/:id
```

#### 投稿

**すべての投稿を取得**
```
GET /api/posts
```

**投稿を作成**
```
POST /api/posts
Content-Type: application/json

{
  "user_id": 1,
  "content": "投稿内容",
  "likes": 0
}
```

### Notion Database版 API (`app_notion.rb`)

#### ユーザー管理

**Notionからユーザーを取得**
```
GET /api/notion/users?platform=twitter
```

**Notionにユーザーを作成**
```
POST /api/notion/users
Content-Type: application/json

{
  "username": "user123",
  "display_name": "User Name",
  "platform": "twitter",
  "bio": "Bio text",
  "interests": ["興味1", "興味2"],
  "interest_details": "詳細な興味の説明",
  "attributes": ["属性1", "属性2"]
}
```

**Notionのユーザーを更新**
```
PUT /api/notion/users/:notion_id
Content-Type: application/json

{
  "display_name": "Updated Name",
  "bio": "Updated bio"
}
```

**Notionのユーザーを削除（アーカイブ）**
```
DELETE /api/notion/users/:notion_id
```

## Notion Databaseのセットアップ

### 1. Notion Integrationを作成

1. https://www.notion.so/my-integrations にアクセス
2. "New integration"をクリック
3. 統合名を入力し、権限を設定
4. "Submit"をクリックしてAPIキーを取得

### 2. Notion Databaseを作成

以下のプロパティを持つデータベースを作成:

| プロパティ名 | タイプ | 説明 |
|-----------|--------|------|
| Username | Title | ユーザー名 |
| Display Name | Text | 表示名 |
| Platform | Select | プラットフォーム (Twitter, Instagram, Facebook) |
| Bio | Text | プロフィール |
| Interests | Multi-select | 興味・関心 |
| Interest Details | Text | 興味の詳細 |
| Attributes | Multi-select | 属性 |
| Following Count | Number | フォロー数 |
| Followers Count | Number | フォロワー数 |

### 3. データベースを統合に接続

1. データベースページを開く
2. 右上の「...」メニューをクリック
3. "Add connections"を選択
4. 作成した統合を選択

### 4. Database IDを取得

データベースのURLから取得:
```
https://www.notion.so/{workspace_name}/{database_id}?v=...
```

## データモデル

### User
- `id`: Integer (主キー)
- `platform`: String (twitter, instagram, facebook)
- `username`: String (ユニーク)
- `display_name`: String
- `bio`: Text
- `interests`: JSON配列
- `interest_details`: Text
- `attributes_list`: JSON配列
- `created_at`: DateTime
- `updated_at`: DateTime

### Relationship
- `id`: Integer (主キー)
- `follower_id`: Integer (フォローするユーザー)
- `following_id`: Integer (フォローされるユーザー)
- `created_at`: DateTime
- `updated_at`: DateTime

### Post
- `id`: Integer (主キー)
- `user_id`: Integer
- `content`: Text
- `likes`: Integer
- `created_at`: DateTime
- `updated_at`: DateTime

## 使用例

### curlでのテスト

```bash
# ヘルスチェック
curl http://localhost:4567/health

# ユーザー作成
curl -X POST http://localhost:4567/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "test_user",
    "display_name": "Test User",
    "platform": "twitter",
    "bio": "Test bio",
    "interests": ["Ruby", "API"],
    "interest_details": "Interested in backend",
    "attributes": ["Engineer"]
  }'

# ユーザー一覧取得
curl http://localhost:4567/api/users

# フォロー関係作成
curl -X POST http://localhost:4567/api/relationships \
  -H "Content-Type: application/json" \
  -d '{"follower_id": 1, "following_id": 2}'
```

## 開発

### 自動リロード

開発中は`rerun`を使用してファイル変更時に自動リロード:

```bash
bundle exec rerun 'ruby app.rb -p 4567'
```

### テスト

```bash
# APIのテスト
curl http://localhost:4567/api/users | jq .
```

## トラブルシューティング

### ポートが使用中の場合

```bash
# 別のポートを使用
bundle exec ruby app.rb -p 4568
```

### データベースのリセット

```bash
rm db/sns_users.db
bundle exec ruby db/migrate.rb
```

## ライセンス

MIT
