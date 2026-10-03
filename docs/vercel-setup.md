# Vercelデプロイ設定ガイド

## 構成

`api/index.rb`の`Handler`がVercelのWEBrickリクエストをRackに変換してRailsを呼び出します。
`vercel.json`は`public`の静的ファイルを先に配信し、それ以外をRailsに渡します。
アプリケーションのソースとプリコンパイル済みassetsをFunctionへ同梱します。
Rubyの対応バージョンは[公式Ruby runtime](https://vercel.com/docs/functions/runtimes/ruby)を参照してください。
Ruby 3.3.12を指定しています。Vercelはpatch指定を無視し最新の3.3.xを使用します。

## Vercelプロジェクト

[Vercel Dashboard](https://vercel.com/dashboard)でGitHubリポジトリを取り込み、Framework PresetをOther、Root Directoryをリポジトリルートに設定します。
Install/Build/Outputは`vercel.json`の設定を使用します。
Production Branchは`main`です。GitHub Actionsを唯一の本番公開経路にするため、Vercelの自動Gitデプロイを無効化してください。
PR Previewを使う場合は本番と別のDB・バケット・SMTP・シークレットを設定してください。ビルドではDBを変更しません。

## Production環境変数

Project → Settings → Environment Variablesに登録します。値をPRやログに貼らないでください。

| 変数 | 内容 |
| --- | --- |
| `DATABASE_URL` | 外部PostgreSQLの接続URL。TLS接続と接続数制限をプロバイダに合わせて設定 |
| `SECRET_KEY_BASE` | `bin/rails secret`で生成した本番専用の値 |
| `APP_HOST` | 実際の公開ホスト名。`https://`やパスを付けない |
| `SMTP_ADDRESS` | SMTPホスト（未指定は`smtp.mailgun.org`） |
| `SMTP_PORT` | STARTTLS対応ポート（未指定は587） |
| `SMTP_USERNAME`, `SMTP_PASSWORD` | メール送信用認証情報 |
| `MAILER_FROM` | SMTPプロバイダで検証した送信元アドレス |
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` | S3バケットへの必要最小限の権限を持つ認証情報 |
| `AWS_REGION`, `AWS_S3_BUCKET` | 画像の永続保管先リージョンとバケット |
| `RAILS_MASTER_KEY` | 暗号化credentialsを利用する場合のみ |

`RAILS_ENV=production`と`BOOTSNAP_CACHE_DIR=/tmp/bootsnap`は`vercel.json`で設定済みです。
S3は非公開バケットとし、署名付きURLで取得します。ローカルDiskへの保存は本番では使用しません。
VercelではImageMagickを前提とせず原本を表示し、CSSで250px以内に収めます。画像解析・プレビュー生成は無効です。Active Jobはinline実行し、画像削除などがリクエスト終了後の非永続workerに残らないようにします。
画像の送信サイズ上限はVercelのFunctionリクエスト制限も受けます。大きな画像が必要な場合はS3への直接アップロードを別途導入してください。

## GitHub Secretsと公開手順

Settings → Secrets and variables → Actionsに`VERCEL_TOKEN`、`VERCEL_ORG_ID`、`VERCEL_PROJECT_ID`を登録します。
デプロイ用Tokenは対象プロジェクトへアクセスできるものを使用します。

`develop`へのPRをマージし、`develop`→`main`のリリースPRをレビュー後にマージします。
Actionsの`Deploy to Vercel`が次の順に処理します。

1. 本番Secretsを事前検証。
2. Vercel CLI 62.2.0で本番設定・環境変数を`.vercel`に取得。
3. `vercel build --prod`でassetsとFunctionを構築。
4. ダウンロードした環境変数をdotenvで読み、本番必須変数を検証して`db:migrate`を実行。
5. マイグレーション成功後に`vercel deploy --prebuilt --prod`で公開。

同時に実行する本番ジョブは1件です。失敗時は後続ステップを中断します。
Git連携による自動公開や手動CLI実行を併用するとこの直列化を迂回するため、単一の公開経路にしてください。
公開前のマイグレーションは既存アプリにも影響します。互換性を保つ段階的なスキーマ変更を使用し、破壊的変更を同時に行わないでください。
`db:seed`は自動実行しません。公開用のテストアカウントは別途用意してください。

手動公開は本番3変数を環境に設定して`bin/deploy`を実行します。
`.vercel`には認証情報を含むためgit管理対象外です。環境変数の取得ファイルをログに表示しないでください。

本番公開前にIssue #23の依存ライブラリのセキュリティ更新を取り込み、統合後のテストを再実行してください。

## 公開後の画面レビュー

Actionsの成功ログとVercel Dashboard → Deploymentsの最新Productionに表示されるURLを開きます。

- `/`：CSS・JavaScript・画像が表示されること。
- `/signup`：登録→確認メールのリンクが公開ホストのHTTPS URLになること。
- `/login`：ログイン後のホームで投稿・画像投稿・削除ができること。
- `/users`：ユーザー一覧からプロフィール、フォロー・解除を確認。
- `/password_resets/new`：再設定メールが届き、公開ホストでパスワードを更新できること。
- 新しいデプロイ後も投稿と画像が残り、ログインが維持されること。

現時点では公開認証情報・本番DB・SMTP・S3・公開URLが提供されておらず、本番公開とこの画面レビューは未実施です。
設定ファイルやローカルテストの成功だけでIssue #21を完了扱いにしないでください。
