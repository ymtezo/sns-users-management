# SNS ユーザ管理システム

クロスプラットフォームのSNSユーザ管理システムです。主要SNSプラットフォーム（Twitter開始）でのユーザー情報、フォロー関係、興味・関心、投稿などを一元管理します。

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

### 基本的な使い方

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

- **フロントエンド**: HTML5, CSS3, Vanilla JavaScript
- **データ保存**: LocalStorage (ブラウザ内ストレージ)
- **スタイリング**: カスタムCSS（Twitter風デザイン）

## プロジェクト構造

```
sns-users-management/
├── index.html          # メインHTMLファイル
├── styles.css          # スタイルシート
├── app.js             # アプリケーションロジック
└── README.md          # このファイル
```

## 今後の拡張予定

- [ ] Instagram対応
- [ ] Facebook対応
- [ ] データのエクスポート/インポート機能
- [ ] 検索・フィルタリング機能
- [ ] グラフ表示（関係性の可視化）
- [ ] バックエンドAPI連携
- [ ] 実際のSNS APIとの連携

## ライセンス

MIT

## 貢献

プルリクエストを歓迎します！