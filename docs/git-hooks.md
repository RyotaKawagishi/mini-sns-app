# Git Hooks

このプロジェクトでは、push前にBrakeman、RuboCop、Slim-Lint、ESLint、Stylelint、RSpecテストを自動実行するpre-push hookを提供しています。

## pre-push hookの概要

- **目的**: push前に変更されたファイルに関連する各種lintツールとRSpecテストを実行し、いずれかが失敗した場合はpushを阻止する
- **メリット**: 
  - セキュリティチェック（Brakeman）
  - コード品質の担保（RuboCop、Slim-Lint、ESLint、Stylelint）
  - 実行時間を短縮（関連specのみ実行）
  - テスト失敗時のpush防止

## セットアップ

### 方法1: セットアップスクリプトの実行（推奨）

```bash
bin/setup-git-hooks
```

`bin/setup` を実行した場合も、自動的にGit hooksがセットアップされます。

### 方法2: 手動でコピー

```bash
cp bin/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-push
```

## 変更ファイルとspecの対応関係

| 変更ファイル | 実行されるspec |
|-------------|---------------|
| app/models/user.rb | spec/models/user_spec.rb |
| app/controllers/users_controller.rb | spec/requests/users_spec.rb |
| app/policies/user_policy.rb | spec/policies/user_policy_spec.rb |
| app/validators/reply_to_user_validator.rb | spec/validators/reply_to_user_validator_spec.rb |
| spec/models/user_spec.rb | spec/models/user_spec.rb（そのまま） |
| config/*, db/*, spec/support/*, spec/factories/* | 全spec |
| app/helpers/*, app/serializers/* 等 | 全spec |

## 実行されるチェック

### Brakeman（セキュリティスキャン）
- **対象**: Rubyファイルがある場合、全アプリケーションをスキャン
- **実行**: `bundle exec brakeman --no-pager --quiet`
- **目的**: SQLインジェクション、XSS、CSRFなどのセキュリティ脆弱性を検出

### RuboCop
- **対象**: 変更された`.rb`ファイル
- **実行**: `bundle exec rubocop <変更されたファイル>`
- **目的**: Rubyコードのスタイルと品質チェック

### Slim-Lint
- **対象**: 変更された`.slim`ファイル
- **実行**: `bundle exec slim-lint <変更されたファイル>`
- **目的**: Slimテンプレートの構文とスタイルチェック

### ESLint
- **対象**: 変更された`.js`ファイル
- **実行**: `npm run lint <変更されたファイル>`
- **注意**: `package.json`が存在し、`npm`がインストールされている必要があります
- **目的**: JavaScriptコードのスタイルと品質チェック

### Stylelint
- **対象**: 変更された`.scss`、`.css`ファイル
- **実行**: `npm run lint:css <変更されたファイル>`
- **注意**: `package.json`が存在し、`npm`がインストールされている必要があります
- **目的**: SCSS/CSSコードのスタイルと品質チェック

### RSpec
- **対象**: 変更されたファイルに関連するspecファイル
- **実行**: `bundle exec rspec <関連するspecファイル>`
- **目的**: 変更されたコードの動作確認

## 動作

1. `git push` 実行時、pre-push hookが自動的に起動
2. push対象の変更ファイルを取得
3. 変更ファイルの種類を判定（Ruby/JavaScript/SCSS/Slim）
4. 各チェックを順次実行:
   - Rubyファイルがある場合: Brakeman → RuboCop → RSpec
   - Slimファイルがある場合: Slim-Lint
   - JavaScriptファイルがある場合: ESLint
   - SCSS/CSSファイルがある場合: Stylelint
5. **すべて成功時**: pushを続行（exit 0）
6. **いずれか失敗時**: pushを阻止（exit 1）

## 注意事項

- `.git/hooks/` はGitで管理されないため、リポジトリをクローンした後は `bin/setup-git-hooks` の実行が必要です
- テストをスキップしてpushしたい場合は `git push --no-verify` を使用できます（非推奨）
