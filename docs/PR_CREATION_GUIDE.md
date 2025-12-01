# Pull Request作成ガイド

このドキュメントは、`.cursor/rules/create-pullrequest.mdc` に基づいたPR作成手順の補足説明です。

## ルールの参照

PR作成時は、必ず `.cursor/rules/create-pullrequest.mdc` の手順に従ってください。

## PRテンプレートの場所

PRテンプレートは `.github/pull_request_template.md` に配置されています（GitHub標準の場所）。

## 手順の補足

### 1. Issue番号の確認

- **必須**: PR作成前に必ず関連Issueを確認
- Issueがない場合は、PRの説明に「Issueなし」と明記

### 2. 差分の確認

```bash
# マージ先ブランチ（デフォルト: main）との差分を確認
git diff origin/main...HEAD | cat
```

### 3. PRテンプレートの取得

PRテンプレートは `.github/pull_request_template.md` から取得します。
コマンドで使用する際は、改行を `\n` で表現した1行の文字列に変換する必要があります。

### 4. PR作成コマンド

```bash
git push origin HEAD && \
echo -e "{{PRテンプレートを1行に変換}}" | \
gh pr create --draft --title "{{PRタイトル}}" --body-file - && \
gh pr view --web
```

**注意点**:
- デフォルトではDraftでPRを作成
- PRタイトルは差分をもとに適切に設定
- テンプレートの各セクションを明確に区分して記載

## よくある質問

### Q: PRテンプレートを1行に変換する方法は？

A: テンプレートファイルの改行を `\n` に置き換えて1行の文字列にします。
例: `sed ':a;N;$!ba;s/\n/\\n/g' .github/pull_request_template.md`

### Q: Issueがない場合はどうすればいい？

A: PRの説明に「Issueなし」と明記し、変更の目的を明確に説明してください。

### Q: マージ先ブランチがmain以外の場合は？

A: ルールの `{{マージ先ブランチ}}` 部分を適切なブランチ名に置き換えてください。

