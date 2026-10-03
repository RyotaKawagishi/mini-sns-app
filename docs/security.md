# セキュリティ監査 (#22)

Ruby 3.3.12 / Rails 8.1.4へ更新し、サポート終了した依存を置き換えます。Vercelの公式Ruby runtimeが3.3.xをサポートするため、この系列を選びます。

動的collection renderを固定partial指定にし、GET/HEADのforwarding URLを統一します。CSRF例外処理、投稿のHTML escape、バインド変数によるSQL、外部referrerへのリダイレクト拒否、永続認証cookieのHttpOnly/SameSite/Secureを確認します。CSPはimportmap nonceに対応し、外部script/object/iframeを制限します。画像はHTTPS/data/blob、Bootstrapのinline styleは許可します。

JSONはSprockets 4のmanifest互換性のため2.xに固定します。Rails 8.1では複数名のGETルート宣言が廃止されたため、following/followersを個別に宣言します。RSpec/RuboCop-RSpec/Brakeman/画像バリデータも新ランタイム対応版へ更新します。

CIのBrakemanは警告を無視せず失敗扱いにします。

レビュー: ログイン、Users/プロフィール、フォロー一覧、投稿・削除、画像、パスワード表示切り替えを確認し、ブラウザー開発者ツールNetworkでCSPとセキュリティヘッダー、Cookieの属性を確認してください。

参考: https://rubyonrails.org/maintenance 、https://www.ruby-lang.org/en/downloads/releases/ 、https://vercel.com/docs/functions/runtimes/ruby
