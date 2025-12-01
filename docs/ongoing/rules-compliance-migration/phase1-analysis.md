# フェーズ1: プロジェクト分析結果

## 1.1 コードベースの詳細分析

### アプリケーション構成

#### コントローラー（8個）
- `ApplicationController` - 基底コントローラー
- `UsersController` - ユーザー管理（index, show, new, create, edit, update, destroy, following, followers）
- `SessionsController` - セッション管理（new, create, destroy）
- `StaticPagesController` - 静的ページ（home, help, about, contact）
- `MicropostsController` - マイクロポスト管理（create, destroy）
- `RelationshipsController` - フォロー関係管理（create, destroy）
- `AccountActivationsController` - アカウント有効化（edit）
- `PasswordResetsController` - パスワードリセット（new, create, edit, update）

#### モデル（3個）
- `User` - ユーザーモデル
- `Micropost` - マイクロポストモデル
- `Relationship` - フォロー関係モデル

#### ルーティング
- RESTfulリソース: `users`, `account_activations`, `password_resets`, `microposts`, `relationships`
- カスタムルート:
  - 静的ページ: `/help`, `/about`, `/contact`
  - 認証: `/signup`, `/login`, `/logout`
  - ユーザー: `following`, `followers` (member routes)

### テスト構成

#### テストフレームワーク
- **Minitest** を使用
- **Fixtures** でテストデータを管理
- テストファイル数: 約20ファイル

#### テストの種類
- Controller tests
- Model tests
- Integration tests
- System tests (Capybara)

### 認証・認可

#### 認証
- セッション認証を実装
- `SessionsHelper` に認証ロジックを配置

#### 認可
- コントローラー内に認可ロジックを実装
  - `logged_in_user` - ログイン確認
  - `correct_user` - ユーザー権限確認
  - `admin_user` - 管理者権限確認

---

## 1.2 依存関係の整理

### 主要なGem依存関係

#### フレームワーク
- `rails` (7.1.5) - Webフレームワーク
- `puma` - Webサーバー

#### データベース
- `sqlite3` (1.6.1) - 開発・テスト環境
- `pg` (1.3.5) - 本番環境

#### フロントエンド
- `bootstrap-sass` (3.4.1) - CSSフレームワーク
- `sassc-rails` (2.1.2) - Sassコンパイラ
- `turbo-rails` - Hotwire Turbo
- `stimulus-rails` - Hotwire Stimulus
- `importmap-rails` - JavaScript管理

#### 認証・セキュリティ
- `bcrypt` (3.1.18) - パスワードハッシュ化

#### ファイルアップロード
- `active_storage_validations` (0.9.8) - Active Storageバリデーション
- `image_processing` (1.12.2) - 画像処理

#### ページネーション
- `will_paginate` (3.3.1) - ページネーション
- `bootstrap-will_paginate` (1.0.0) - Bootstrap統合

#### テスト
- `minitest` (5.18.0) - テストフレームワーク
- `minitest-reporters` (1.6.0) - テストレポート
- `capybara` (3.38.0) - システムテスト
- `selenium-webdriver` (4.8.3) - ブラウザ自動化
- `rails-controller-testing` (1.0.5) - コントローラーテスト支援

#### 開発ツール
- `debug` - デバッガー
- `web-console` - ブラウザコンソール
- `guard` (2.18.0) - ファイル監視
- `guard-minitest` (2.4.6) - Minitest自動実行

#### その他
- `faker` (2.21.0) - テストデータ生成
- `jbuilder` - JSONビルダー

### ルールで要求されているが未導入のGem

#### テスト関連
- `rspec-rails` - RSpec（ルールではRSpecを前提）
- `factory_bot_rails` - FactoryBot（ルールではFactoryBotを前提）

#### 認可関連
- `pundit` - Policyベースの認可（ルールではPolicyへの分離を要求）

#### API関連
- `blueprinter` - JSONシリアライザ（ルールでは使用を前提）
- `committee-rails` - APIスキーマ検証（ルールでは使用を前提）

---

## 1.3 影響範囲の特定

### ルールとの不一致による影響範囲

#### 重大な不一致

1. **テストフレームワーク**
   - 影響範囲: `test/` ディレクトリ全体
   - 影響ファイル数: 約20ファイル
   - 対応: RSpecへの移行、またはルールの調整

2. **コントローラーのルーティング**
   - 影響範囲:
     - `config/routes.rb`
     - `app/controllers/static_pages_controller.rb`
     - `app/controllers/sessions_controller.rb`
     - `app/controllers/users_controller.rb` (following, followers)
   - 対応: ルールの調整（Webアプリ向けに）

3. **認可ロジック**
   - 影響範囲:
     - `app/controllers/application_controller.rb`
     - `app/controllers/users_controller.rb`
     - `app/controllers/microposts_controller.rb`
   - 対応: Pundit導入とPolicyへの移行

#### 中程度の不一致

4. **Yard記法のドキュメンテーション**
   - 影響範囲: 全モデル・コントローラーのメソッド
   - 影響ファイル数: 約15ファイル
   - 対応: Yard記法の追加

5. **マイグレーションコメント**
   - 影響範囲: `db/migrate/` 配下の全ファイル（11ファイル）
   - 対応: コメントの追加

6. **カスタムバリデーション**
   - 影響範囲: `app/models/micropost.rb`
   - 対応: Validatorへの分離

---

## 1.4 技術的負債の洗い出し

### 確認された技術的負債

1. **認可ロジックの分散**
   - コントローラー内に認可ロジックが散在
   - テストが困難
   - 再利用性が低い

2. **カスタムバリデーションのモデル内実装**
   - `Micropost` モデル内にバリデーションロジックが直接実装
   - 再利用性が低い

3. **ドキュメンテーション不足**
   - メソッドのドキュメンテーションがない
   - コードの意図が不明確

4. **テストフレームワークの不一致**
   - ルールと実装が不一致
   - 規約の適用が困難

---

## 1.5 移行の優先順位

### 優先度: 高
1. ルールの調整（Webアプリ向け）
2. 認可ロジックの分離（Pundit導入）
3. カスタムバリデーションの分離

### 優先度: 中
4. Yard記法の追加
5. マイグレーションコメントの追加

### 優先度: 低（オプション）
6. テストフレームワークの移行（RSpec）
7. API設計ツールの導入（現時点ではAPIを提供していないため）

