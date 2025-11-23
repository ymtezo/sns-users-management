#!/bin/bash
# SNS User Management System - Quick Setup Script
# このスクリプトはプロジェクトのセットアップを自動化します

set -e

echo "========================================="
echo "SNSユーザ管理システム セットアップ"
echo "========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "エラー: このスクリプトはプロジェクトのルートディレクトリで実行してください"
    exit 1
fi

echo "📦 セットアップを開始します..."
echo ""

# Frontend setup
echo "✅ フロントエンド版の準備完了"
echo "   - index.html, app.js, styles.css が利用可能です"
echo ""

# Check for Ruby
if command -v ruby &> /dev/null; then
    RUBY_VERSION=$(ruby -v)
    echo "✅ Ruby が見つかりました: $RUBY_VERSION"
    
    # Check for bundler
    if command -v bundle &> /dev/null; then
        echo "✅ Bundler が見つかりました"
        
        echo ""
        echo "📦 Ruby依存関係をインストール中..."
        bundle config set --local path 'vendor/bundle'
        bundle install
        
        echo ""
        echo "🗄️  データベースをセットアップ中..."
        bundle exec ruby db/migrate.rb
        
        echo ""
        echo "✅ Ruby API版のセットアップ完了"
    else
        echo "⚠️  Bundler が見つかりません"
        echo "   インストールするには: gem install bundler"
    fi
else
    echo "⚠️  Ruby が見つかりません（Ruby API版を使用する場合は Ruby 3.2+ が必要です）"
fi

echo ""
echo "========================================="
echo "セットアップ完了！"
echo "========================================="
echo ""
echo "🚀 起動方法:"
echo ""
echo "【フロントエンド版】"
echo "  1. ブラウザで index.html を直接開く"
echo "  または"
echo "  2. python -m http.server 8000"
echo "     その後 http://localhost:8000 にアクセス"
echo ""

if command -v ruby &> /dev/null && command -v bundle &> /dev/null; then
    echo "【Ruby API版 - SQLite】"
    echo "  bundle exec ruby app.rb -p 4567"
    echo "  その後 http://localhost:4567/health でテスト"
    echo ""
    echo "【Ruby API版 - Notion連携】"
    echo "  1. .env ファイルを作成（.env.example を参考に）"
    echo "  2. NOTION_API_KEY と NOTION_DATABASE_ID を設定"
    echo "  3. source .env"
    echo "  4. bundle exec ruby app_notion.rb -p 4568"
    echo ""
fi

echo "📚 詳細なドキュメント:"
echo "  - README.md - 全体概要"
echo "  - README_RUBY.md - Ruby API詳細"
echo "  - IMPLEMENTATION.md - 実装サマリー"
echo ""
echo "========================================="
