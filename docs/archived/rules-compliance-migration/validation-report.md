# ルールとコードの整合性検証結果

> **注意**: このドキュメントは検証結果の詳細版です。移行計画は `migration-plan.md` を参照してください。

## 検証日
2024年（検証実施日を記入）

## 検証対象
- `.cursor/rules/` 配下の全ルールファイル
- プロジェクトの主要コードベース

---

## 重大な不一致

### 1. テストフレームワーク

**ルール**: RSpecとFactoryBotを使用
- `testing.mdc` は RSpec を前提とした記述

**現状**: Minitestとfixturesを使用
- `test/` ディレクトリにMinitestのテストファイル
- `Gemfile` に RSpec/FactoryBot の依存関係なし

**影響範囲**:
- `test/` ディレクトリ配下の全テストファイル
- テストデータの作成方法（fixtures → FactoryBot）

**優先度**: 🔴 高（テスト規約全体が適用不可）

---

### 2. コントローラーのルーティング

**ルール**: DHHルーティングのみ（index, show, create, update, destroy）
- `controllers.mdc` でカスタムアクションを禁止

**現状**: カスタムルートが多数存在
- `get "/help"`, `get "/about"`, `get "/contact"` (static_pages)
- `get "/signup"`, `get "/login"`, `post "/login"`, `delete "/logout"` (sessions)
- `member do` ブロックで `following` と `followers` アクション

**影響範囲**:
- `config/routes.rb`
- `app/controllers/users_controller.rb` (following, followers)
- `app/controllers/sessions_controller.rb` (new, create, destroy)
- `app/controllers/static_pages_controller.rb` (help, about, contact)

**優先度**: 🔴 高（ルーティング設計の根本的な不一致）

---

### 3. 認可ロジックの分離

**ルール**: 認可ロジックは `app/policies` に配置
- `policies.mdc` で Policy への分離を要求

**現状**: コントローラー内に実装
- `correct_user`, `admin_user` メソッドがコントローラー内に存在
- `logged_in_user` が ApplicationController に実装

**影響範囲**:
- `app/controllers/users_controller.rb`
- `app/controllers/microposts_controller.rb`
- `app/controllers/application_controller.rb`

**優先度**: 🔴 高（責務の分離原則に違反）

---

### 4. API設計ツール

**ルール**: Blueprinter（JSONシリアライザ）、Committee Rails（APIスキーマ検証）
- `general.mdc` と `serializers.mdc` で使用を前提

**現状**: 使用されていない
- `Gemfile` に該当gemなし
- `app/serializers/` ディレクトリなし
- 現時点ではAPIエンドポイントを提供していない

**優先度**: 🟡 中（現時点ではAPIを提供していないため影響は限定的）

---

## 中程度の不一致

### 5. Yard記法のドキュメンテーション

**ルール**: メソッドにYard記法（`@param`, `@return`, `@raise`）を必須
- `general.mdc` で要求

**現状**: ドキュメンテーションコメントがない
- モデルのメソッドにコメントなし

**影響範囲**:
- `app/models/user.rb`
- `app/models/micropost.rb`
- `app/models/relationship.rb`
- その他のモデルメソッド

**優先度**: 🟡 中（コードの可読性・保守性に影響）

---

### 6. マイグレーションのコメント

**ルール**: カラムに論理名（日本語）をコメントとして追加
- `migration.mdc` で要求

**現状**: コメントがない
- 全マイグレーションファイルにコメントなし

**影響範囲**:
- `db/migrate/*.rb` の全ファイル（11ファイル）

**優先度**: 🟡 中（データベース設計の可読性に影響）

---

### 7. ActiveRecordの`.merge`使用

**ルール**: リレーション先のカラムでの絞り込みは`.merge`を使う
- `general.mdc` で推奨

**現状**: 使用されていない
- `app/models/user.rb` の `feed` メソッドで直接 `where` を使用

**影響範囲**:
- `app/models/user.rb` の `feed` メソッド

**優先度**: 🟢 低（機能的な問題はないが、規約に準拠していない）

---

### 8. カスタムバリデーション

**ルール**: カスタムvalidatorの実装は控えめに
- `models.mdc` と `validators.mdc` で推奨

**現状**: モデル内に直接実装
- `validate :validate_reply_to_user`, `validate :cannot_reply_to_self` がモデル内に直接実装

**影響範囲**:
- `app/models/micropost.rb`

**優先度**: 🟡 中（再利用性とテスタビリティに影響）

---

## 軽微な不一致

### 9. ディレクトリ構造

**ルール**: `app/serializers/`, `app/policies/`, `app/validators/`, `app/decorators/` を使用

**現状**: これらのディレクトリが存在しない

**優先度**: 🟢 低（現時点では使用していないため）

---

## 準拠している点

1. ✅ モデルの基本構造: `ApplicationRecord` を継承
2. ✅ マイグレーションファイルの命名規則: `YYYYMMDDHHMMSS_create_table_name.rb` 形式
3. ✅ マイグレーションバージョン: `ActiveRecord::Migration[7.1]` で指定

---

## まとめ

### 不一致の統計
- 重大な不一致: 4件
- 中程度の不一致: 4件
- 軽微な不一致: 1件

### 主な課題
1. **テストフレームワーク**: RSpecへの移行が必要
2. **ルーティング設計**: DHHルーティングへの準拠またはルールの調整
3. **認可ロジック**: Policyへの分離が必要
4. **ドキュメンテーション**: Yard記法の追加が必要

### 推奨される対応方針
1. プロジェクトの性質（Webアプリ vs API）を考慮したルール調整
2. 段階的な移行（優先度の高いものから順に実施）
3. 既存機能への影響を最小限に抑えた移行戦略

