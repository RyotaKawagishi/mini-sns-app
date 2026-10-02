# mainブランチ保護と本番デプロイ

## mainへの変更

このリポジトリの`develop`から`main`へのPRのみ許可します。
GitHubのmainブランチ保護でPR経由の変更を必須にし、
`prevent-direct-merge`と`lint-and-test`を必須チェックに設定します。
管理者にも保護を適用し、直接push、force push、ブランチ削除を禁止します。
ワークフロー単独ではマージや直接pushを禁止できません。

## Vercelワークフロー

mainへのpushまたはmainを指定した手動実行で本番デプロイします。
他のブランチを指定した手動実行はスキップします。
本番デプロイは同時に1件だけ実行します。

GitHubのSettings → Secrets and variables → Actionsに以下を登録してください。
値をPR、ログ、チャットに記載しないでください。

- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

## 公開前の未完了項目

ワークフローの追加だけではRailsアプリの本番公開は完了しません。
公開先とRailsの実行方式を決定したうえで、以下を設定・検証します。

- Railsのビルドと起動（既存DockerfileはVercel向けには未検証）
- PostgreSQLの`DATABASE_URL`とマイグレーション手順
- `RAILS_MASTER_KEY`または本番の`SECRET_KEY_BASE`
- 画像アップロードの永続ストレージ（現在の本番設定はローカルDisk）
- 公開URLに合わせたメールURLとSMTP設定（現在はRenderのURL）
- 本番URLでログイン・投稿・画像・メール送信の動作確認

本番認証情報が未登録の状態ではデプロイの事前確認が失敗します。
PR #29のワークフロー整備とIssue #21の本番公開完了は区別してください。
