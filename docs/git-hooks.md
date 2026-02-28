# Git Hooks

このプロジェクトでは、push前にRSpecテストを自動実行するpre-push hookを提供しています。

## pre-push hookの概要

- **目的**: push前に変更されたファイルに関連するRSpecテストのみを実行し、テストが失敗した場合はpushを阻止する
- **メリット**: 実行時間を短縮（関連specのみ実行）、テスト失敗時のpush防止

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

## 動作

1. `git push` 実行時、pre-push hookが自動的に起動
2. push対象の変更ファイルを取得
3. 変更ファイルから関連するspecを特定
4. 関連specのみを実行
5. **成功時**: pushを続行（exit 0）
6. **失敗時**: pushを阻止（exit 1）

## 注意事項

- `.git/hooks/` はGitで管理されないため、リポジトリをクローンした後は `bin/setup-git-hooks` の実行が必要です
- テストをスキップしてpushしたい場合は `git push --no-verify` を使用できます（非推奨）
