# Vercelデプロイ設定ガイド

このドキュメントでは、Vercelへのデプロイ設定手順を説明します。

## 前提条件

- Vercelアカウントを持っていること
- GitHubリポジトリへのアクセス権限があること

## Vercel側の設定手順

### 1. Vercelプロジェクトの作成

1. [Vercel Dashboard](https://vercel.com/dashboard)にログイン
2. 「Add New...」→「Project」をクリック
3. GitHubリポジトリを選択
4. プロジェクト設定を入力：
   - **Framework Preset**: Other
   - **Root Directory**: `./`（デフォルト）
   - **Build Command**: `bundle install && npm ci && bin/rails assets:precompile`
   - **Output Directory**: `public`
   - **Install Command**: `bundle install && npm ci`

### 2. 環境変数の設定

Vercelのプロジェクト設定で以下の環境変数を設定：

#### 必須環境変数

- `RAILS_ENV`: `production`
- `RAILS_LOG_TO_STDOUT`: `true`
- `RAILS_MASTER_KEY`: Rails credentialsのmaster key
- `DATABASE_URL`: PostgreSQLデータベースの接続URL
- `SECRET_KEY_BASE`: Railsのシークレットキー（`bin/rails secret`で生成）

#### 推奨環境変数

- `RAILS_SERVE_STATIC_FILES`: `true`（静的ファイルの配信）
- `RAILS_MAX_THREADS`: `5`（デフォルト）

### 3. PostgreSQLデータベースの設定

1. Vercelのプロジェクト設定で「Storage」タブを開く
2. 「Create Database」→「Postgres」を選択
3. データベース名を入力して作成
4. 接続URLを`DATABASE_URL`環境変数に設定

### 4. GitHub Secretsの設定

GitHub Actionsで自動デプロイするために、以下のSecretsを設定：

1. GitHubリポジトリの「Settings」→「Secrets and variables」→「Actions」を開く
2. 以下のSecretsを追加：
   - `VERCEL_TOKEN`: Vercelのアクセストークン（Settings → Tokensで生成）
   - `VERCEL_ORG_ID`: VercelのOrganization ID（Settings → Generalで確認）
   - `VERCEL_PROJECT_ID`: VercelのProject ID（プロジェクト設定で確認）

### 5. ブランチ保護ルールの設定（推奨）

GitHubリポジトリの「Settings」→「Branches」で、mainブランチに以下の保護ルールを設定：

- ✅ Require a pull request before merging
- ✅ Require approvals: 1
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Do not allow bypassing the above settings

## デプロイフロー

### 通常のデプロイフロー

1. `develop`ブランチから`feature/*`ブランチを作成
2. 変更をコミット・プッシュ
3. `develop`ブランチへのPRを作成・マージ
4. `develop`ブランチから`main`ブランチへのPRを作成
5. PRがマージされると、GitHub Actionsが自動的にVercelへデプロイ

### 手動デプロイ

GitHub Actionsの「Deploy to Vercel」ワークフローを手動実行することも可能です。

## トラブルシューティング

### ビルドエラー

- Rubyのバージョンが正しく設定されているか確認
- 依存関係が正しくインストールされているか確認
- 環境変数が正しく設定されているか確認

### データベース接続エラー

- `DATABASE_URL`が正しく設定されているか確認
- PostgreSQLデータベースが作成されているか確認
- データベースのマイグレーションが実行されているか確認

### デプロイが失敗する

- GitHub Secretsが正しく設定されているか確認
- Vercelのプロジェクト設定が正しいか確認
- ログを確認してエラーの原因を特定

## 参考リンク

- [Vercel Documentation](https://vercel.com/docs)
- [Rails on Vercel](https://vercel.com/docs/frameworks/ruby-on-rails)
