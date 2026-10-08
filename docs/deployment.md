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

## 本番アプリの設定

RailsのHandler、ビルド、公開前のDBマイグレーション、SMTPとS3を実装しています。
詳細と必須環境変数は[vercel-setup.md](vercel-setup.md)を参照してください。

本番認証情報・DB・SMTP・S3・公開URLは未提供です。本番デプロイと画面の動作確認は未実施です。
PR #28の設定整備とIssue #21の本番公開完了は区別してください。
