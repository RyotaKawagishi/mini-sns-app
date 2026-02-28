# mini-sns-app

SNSアプリケーションのサンプル実装です。ユーザー管理、マイクロポスト、フォロー機能を提供します。

## 主要機能

- **ユーザー管理**: ユーザー登録・認証、アカウント有効化（メール認証）、パスワードリセット、プロフィール編集
- **マイクロポスト**: マイクロポストの投稿・削除、画像アップロード、リプライ機能
- **フォロー機能**: ユーザー間のフォロー・アンフォロー、フォロー中・フォロワー一覧表示

## 技術スタック

- **フレームワーク**: Ruby on Rails 7.1.5
- **言語**: Ruby 3.2.6
- **データベース**: SQLite3 (開発・テスト), PostgreSQL (本番)
- **フロントエンド**: Bootstrap 3.4.1, Stimulus, Turbo
- **テンプレートエンジン**: Slim
- **テストフレームワーク**: RSpec
- **認可**: Pundit

## 必要な環境

- Ruby 3.2.6
- Rails 7.1.5
- Node.js 20以上
- SQLite3
- Bundler

## セットアップ手順

### 1. リポジトリのクローン

```bash
git clone https://github.com/RyotaKawagishi/mini-sns-app.git
cd mini-sns-app
```

### 2. 依存関係のインストール

#### Ruby依存関係のインストール

```bash
bundle install
```

#### Node.js依存関係のインストール

```bash
npm ci
```

### 3. データベースのセットアップ

```bash
bin/rails db:prepare
```

このコマンドは以下を実行します：
- データベースの作成
- マイグレーションの実行
- スキーマの読み込み

### 4. サンプルデータの投入（オプション）

開発環境でサンプルデータを使用する場合：

```bash
bin/rails db:seed
```

これにより、以下のサンプルデータが作成されます：
- サンプルユーザー（管理者1名、一般ユーザー101名）
- サンプルマイクロポスト
- フォロー関係

### 5. Git Hooksのセットアップ（推奨）

pre-push hookをセットアップすると、push前に自動的にlintチェックとテストが実行されます：

```bash
bin/setup-git-hooks
```

### 6. サーバーの起動

```bash
bin/rails server
```

または

```bash
bin/dev
```

ブラウザで `http://localhost:3000` にアクセスしてください。

### 7. 自動セットアップ（推奨）

上記の手順を自動で実行する場合：

```bash
bin/setup
```

このコマンドは以下を実行します：
- 依存関係のインストール（bundle install）
- データベースの準備（bin/rails db:prepare）
- ログと一時ファイルのクリア
- Git hooksのセットアップ

## テストの実行

### すべてのテストを実行

```bash
bundle exec rspec
```

### 特定のテストファイルを実行

```bash
bundle exec rspec spec/models/user_spec.rb
```

## 開発ガイドライン

### コーディング規約

プロジェクトのコーディング規約は `.cursor/rules/` ディレクトリに記載されています。

- [コーディング規約](.cursor/rules/general.mdc)
- [コントローラー規約](.cursor/rules/controllers.mdc)
- [モデル規約](.cursor/rules/models.mdc)

### Lintとフォーマット

#### Ruby

```bash
bundle exec rubocop
bundle exec rubocop -a  # 自動修正
```

#### JavaScript

```bash
npm run lint
npm run lint:fix  # 自動修正
```

#### CSS/SCSS

```bash
npm run lint:css
npm run lint:css:fix  # 自動修正
```

#### Slim

```bash
bundle exec slim-lint
```

### セキュリティチェック

```bash
bundle exec brakeman
```

## プロジェクト構成

```
mini-sns-app/
├── app/
│   ├── controllers/    # コントローラー
│   ├── models/         # モデル
│   ├── views/          # ビュー（Slim）
│   ├── policies/       # 認可ロジック（Pundit）
│   ├── validators/     # カスタムバリデーション
│   ├── decorators/     # 表示ロジック
│   └── jobs/           # 非同期処理
├── config/             # 設定ファイル
├── db/                 # データベース関連
├── spec/               # テストファイル
├── bin/                # 実行可能スクリプト
└── docs/               # ドキュメント
```

## ライセンス

このプロジェクトはMITライセンスのもとで公開されています。
