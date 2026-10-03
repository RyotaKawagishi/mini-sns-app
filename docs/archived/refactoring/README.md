# Issue #13 リファクタリング（2026-10-03）

モデル、コントローラ、ヘルパー、ビュー、既存specを確認し、既存機能への影響とSQL負荷からフィード取得とユーザー画面の重複を優先した。認証・投稿・画像・返信の仕様や公開メソッドは維持する。

- `User#feed`: フォロー先への多重JOINとDISTINCTを、関連IDのSQLサブクエリへ変更。自分・フォロー先・自分宛の返信をORで取得し、既存のユーザー/画像preloadと新しい順の並びを維持。
- `UsersController`: ユーザー取得とフォロー/フォロワー画面生成をprivateメソッドへ抽出。ログイン確認を先に実行する。
- 小さい変更で十分なため新規クラスは導入しない。認証や他の機能改善は別Issueで扱う。

## 確認

全73 spec成功（既存71件＋回帰2件）。既存のRelation同士のSQL比較を、重複がないという同じ仕様の配列検証へ修正。
SQL通知によって、関連IDをRubyへロードしない1クエリ・JOIN/DISTINCTなしを確認。返信・複数フォロワー・ページ先頭・並びも検証。

`RAILS_ENV=test bundle exec rails runner docs/archived/refactoring/feed_benchmark.rb`
でSQLite、150投稿、対象作者の41フォロワー、30件×100回、query cacheなしの実測。旧0.0406秒、新0.0112秒（約3.6倍）。結果IDは一致。EXPLAINは全投稿走査＋JOINから既存インデックスを利用するMULTI-INDEX ORへ変化。本番PostgreSQLの速度保証ではない。測定データはtransaction rollbackする。

RuboCopは基準ブランチのrubocop-rspec 2 / RuboCop 1.85互換性問題で起動失敗。依存更新PR側で対応予定。
