# Git Hooks

このプロジェクトでは、push前にRuboCop、ESLint、RSpecテストを自動実行するpre-push hookを提供しています。

## pre-push hookの概要

- **目的**: push前に変更されたファイルに関連するRuboCop、ESLint、RSpecテストを実行し、いずれかが失敗した場合はpushを阻止する
- **メリット**: 
  - コード品質の担保（RuboCop、ESLint）
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

### RuboCop
- **対象**: 変更された`.rb`ファイル
- **実行**: `bundle exec rubocop <変更されたファイル>`

### ESLint
- **対象**: 変更された`.js`ファイル
- **実行**: `npm run lint <変更されたファイル>`
- **注意**: `package.json`が存在し、`npm`がインストールされている必要があります

### RSpec
- **対象**: 変更されたファイルに関連するspecファイル
- **実行**: `bundle exec rspec <関連するspecファイル>`

## 動作

1. `git push` 実行時、pre-push hookが自動的に起動
2. push対象の変更ファイルを取得
3. 変更ファイルの種類を判定（Ruby/JavaScript）
4. 各チェックを順次実行:
   - Rubyファイルがある場合: RuboCop → RSpec
   - JavaScriptファイルがある場合: ESLint
5. **すべて成功時**: pushを続行（exit 0）
6. **いずれか失敗時**: pushを阻止（exit 1）

## 注意事項

- `.git/hooks/` はGitで管理されないため、リポジトリをクローンした後は `bin/setup-git-hooks` の実行が必要です
- テストをスキップしてpushしたい場合は `git push --no-verify` を使用できます（非推奨）
