# 移行作業チェックリスト

このチェックリストは、ルール準拠への移行作業を進める際の進捗管理に使用します。

## 全体進捗

- [ ] フェーズ1: 準備と基盤整備
- [ ] フェーズ2: ドキュメンテーションと軽微な修正
- [x] フェーズ3: カスタムバリデーションの分離
- [ ] フェーズ3.5: 開発環境でのメール送信設定
- [ ] フェーズ4: 認可ロジックの分離
- [ ] フェーズ5: ルーティングの見直し（オプション）
- [ ] フェーズ6: テストフレームワークの移行（オプション）
- [ ] フェーズ7: API設計ツールの導入（将来）

---

## フェーズ1: 準備と基盤整備

### プロジェクト分析
- [x] 現状のコードベースの詳細分析
  - 分析結果: `phase1-analysis.md` に記録
- [x] 依存関係の整理
  - Gemfileの依存関係を整理し、`phase1-analysis.md` に記録
- [x] 影響範囲の特定
  - ルールとの不一致による影響範囲を特定し、`phase1-analysis.md` に記録
- [x] 技術的負債の洗い出し
  - 技術的負債を洗い出し、`phase1-analysis.md` に記録

### ルールの調整検討
- [x] Webアプリケーション向けのルール調整案の作成
  - 調整案: `phase1-rule-adjustment-proposal.md` に記録
- [ ] ルールファイルの更新（必要に応じて）
  - 調整案の承認後に実施
- [ ] チーム内での合意形成
  - 調整案のレビュー待ち

**完了日**: _______________

---

## フェーズ2: ドキュメンテーションと軽微な修正

### Yard記法の追加

#### Userモデル
- [x] `digest` メソッド
- [x] `new_token` メソッド
- [x] `remember` メソッド
- [x] `session_token` メソッド
- [x] `authenticated?` メソッド
- [x] `forget` メソッド
- [x] `activate` メソッド
- [x] `send_activation_email` メソッド
- [x] `create_reset_digest` メソッド
- [x] `send_password_reset_email` メソッド
- [x] `password_reset_expired?` メソッド
- [x] `feed` メソッド
- [x] `follow` メソッド
- [x] `unfollow` メソッド
- [x] `following?` メソッド
- [x] `downcase_email` メソッド（private）
- [x] `create_activation_digest` メソッド（private）

#### Micropostモデル
- [x] `set_in_reply_to` メソッド
- [x] `validate_reply_to_user` メソッド
- [x] `prepend_mention_to_content` メソッド（private）
- [x] `cannot_reply_to_self` メソッド（private）

#### その他のモデル
- [x] Relationshipモデル（メソッドなしのため完了）

#### コントローラー
- [x] UsersControllerの主要メソッド（index, show, new, create, edit, update, destroy, following, followers）
- [x] MicropostsControllerの主要メソッド（create, destroy）
- [x] SessionsControllerの主要メソッド（new, create, destroy）
- [x] ApplicationControllerのlogged_in_userメソッド

### マイグレーションコメントの追加
- [x] `20250401183153_create_users.rb`
- [x] `20250402064254_add_index_to_users_email.rb`（インデックス追加のみのためコメント不要）
- [x] `20250402074002_add_password_digest_to_users.rb`
- [x] `20250403182422_add_remember_digest_to_users.rb`
- [x] `20250407135819_add_admin_to_users.rb`
- [x] `20250408075815_add_activation_to_users.rb`
- [x] `20250409062419_add_reset_to_users.rb`
- [x] `20250409092705_create_microposts.rb`
- [x] `20250410082210_create_active_storage_tables.active_storage.rb`（Active Storageのマイグレーションのためコメント不要）
- [x] `20250414114028_create_relationships.rb`
- [x] `20250417061830_add_in_reply_to_column_to_microposts.rb`

**完了日**: _______________

---

## フェーズ3: カスタムバリデーションの分離

### Validatorの作成
- [x] `app/validators/` ディレクトリの作成
- [x] `ReplyToUserValidator` の作成
- [x] `CannotReplyToSelfValidator` の作成
- [x] エラーメッセージの多言語化対応
  - `config/locales/defaults/ja.yml` の作成
  - `config/locales/en.yml` にエラーメッセージを追加

### モデルの更新
- [x] `Micropost` モデルのバリデーションを更新
- [x] 既存のバリデーションメソッドの削除（`validate_reply_to_user`, `cannot_reply_to_self`を削除）
- [x] テストの更新（エラーメッセージの形式に合わせて修正）
- [x] 動作確認（112 tests, 544 assertions, 0 failures）

**完了日**: _______________

---

## フェーズ3.5: 開発環境でのメール送信設定

### letter_openerの導入
- [x] `letter_opener` gemの追加（Gemfile）
- [x] `bundle install` の実行
- [x] `development.rb` にletter_openerの設定を追加
  - `config.action_mailer.delivery_method = :letter_opener`
  - `config.action_mailer.perform_deliveries = true`

### 動作確認
- [ ] アカウント有効化メールの送信確認
  - ユーザー登録時にメールがブラウザで開くことを確認

**完了日**: _______________

**目的**: Mailgunなどの有料サービスを使わずに、開発環境でメール送信を確認できるようにする。

---

## フェーズ4: 認可ロジックの分離

### Punditの導入
- [ ] Pundit gemの追加（Gemfile）
- [ ] `bundle install`
- [ ] `ApplicationPolicy` の作成
- [ ] Punditの設定

### Policyの作成
- [ ] `UserPolicy` の作成
  - [ ] `index?` メソッド
  - [ ] `show?` メソッド
  - [ ] `create?` メソッド
  - [ ] `update?` メソッド
  - [ ] `destroy?` メソッド
  - [ ] `following?` メソッド
  - [ ] `followers?` メソッド
- [ ] `MicropostPolicy` の作成
  - [ ] `create?` メソッド
  - [ ] `destroy?` メソッド

### コントローラーの更新
- [ ] `UsersController` の更新
- [ ] `MicropostsController` の更新
- [ ] `ApplicationController` の更新
- [ ] 既存の `before_action` の削除
- [ ] テストの更新
- [ ] 動作確認

**完了日**: _______________

---

## フェーズ5: ルーティングの見直し（オプション）

### ルーティング設計の検討
- [ ] 現状のルーティングの評価
- [ ] DHHルーティングへの移行可能性の検討
- [ ] 代替案の検討
- [ ] 決定

### ルーティングの更新（決定した場合）
- [ ] `routes.rb` の更新
- [ ] コントローラーの更新
- [ ] ビューの更新（必要に応じて）
- [ ] テストの更新
- [ ] 動作確認

**完了日**: _______________

---

## フェーズ6: テストフレームワークの移行（オプション）

### RSpecの導入準備
- [ ] RSpec gemの追加（Gemfile）
- [ ] FactoryBot gemの追加
- [ ] `bundle install`
- [ ] `rails generate rspec:install`
- [ ] 設定ファイルの調整

### テストの移行
- [ ] モデルテストの移行
- [ ] コントローラーテストの移行
- [ ] 統合テストの移行
- [ ] FactoryBotの設定
- [ ] FixturesからFactoryBotへの移行
- [ ] テストカバレッジの確認

**完了日**: _______________

---

## フェーズ7: API設計ツールの導入（将来）

### APIエンドポイントの設計
- [ ] API要件の定義
- [ ] OpenAPI仕様の作成

### ツールの導入
- [ ] Blueprinter gemの追加
- [ ] Committee Rails gemの追加
- [ ] Serializerの実装
- [ ] APIテストの実装

**完了日**: _______________

---

## 最終確認

- [ ] すべてのテストが通過
- [ ] コードレビュー完了
- [ ] ドキュメント更新完了
- [ ] デプロイ前の最終確認

**完了日**: _______________

---

## Pull Request作成（各フェーズ完了時）

### PR作成前の確認
- [ ] 関連Issueの確認（Issueがない場合は「Issueなし」と明記）
- [ ] マージ先ブランチとの差分確認（`git diff origin/main...HEAD | cat`）
- [ ] PRテンプレート（`.github/pull_request_template.md`）の内容確認

### PR作成
- [ ] `.cursor/rules/create-pullrequest.mdc` の手順に従ってPRを作成
- [ ] DraftでPRを作成（指示がない限り）
- [ ] PRタイトルを適切に設定
- [ ] PRテンプレートの各セクションを記入
- [ ] ブラウザでPRを確認

**参考**: `docs/PR_CREATION_GUIDE.md` を参照

