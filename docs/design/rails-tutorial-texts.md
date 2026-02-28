# Rails Tutorial由来のテキスト一覧

このドキュメントは、デザインからRails Tutorialで作ったと分かる文章を洗い出したものです。

## 1. ページタイトル（ブラウザタブ）

**ファイル**: `app/helpers/application_helper.rb`
- **内容**: `"Ruby on Rails Tutorial Sample App"`
- **場所**: `base_title` 変数

## 2. ヘッダーロゴ

**ファイル**: `app/views/layouts/_header.html.erb`
- **内容**: `"sample app"`
- **場所**: ナビゲーションバーのロゴテキスト

## 3. フッター

**ファイル**: `app/views/layouts/_footer.html.erb`
- **内容**: 
  - `"The Ruby on Rails Tutorial by Michael Hartl"`
  - `"News"` リンク（`https://news.railstutorial.org/`）

## 4. ホームページ（ログアウト時）

**ファイル**: `app/views/static_pages/_user_logged_out.html.erb`
- **内容**:
  - `"Welcome to the Sample App"`
  - `"This is the home page for the Ruby on Rails Tutorial sample application."`
  - Railsロゴ画像（`rails.svg`）とRuby on Railsへのリンク

## 5. Aboutページ

**ファイル**: `app/views/static_pages/about.html.erb`
- **内容**:
  - `"Ruby on Rails Tutorial is a book and screencast to teach web development with Ruby on Rails."`
  - `"This is the sample application for the tutorial."`

## 6. Helpページ

**ファイル**: `app/views/static_pages/help.html.erb`
- **内容**:
  - `"Get help on the Ruby on Rails Tutorial at the Rails Tutorial Help page."`
  - `"To get help on this sample app, see the Ruby on Rails Tutorial book."`

## 7. Contactページ

**ファイル**: `app/views/static_pages/contact.html.erb`
- **内容**:
  - `"Contact the Ruby on Rails Tutorial about the sample app at the contact page."`

## 8. メールテンプレート

### アカウント有効化メール

**ファイル**: 
- `app/views/user_mailer/account_activation.html.erb`
- `app/views/user_mailer/account_activation.text.erb`

- **内容**:
  - `"Sample App"`（HTML版の見出し）
  - `"Welcome to the Sample App! Click on the link below to activate your account:"`

### パスワードリセットメール

**ファイル**: 
- `app/views/user_mailer/password_reset.html.erb`
- `app/views/user_mailer/password_reset.text.erb`

- **内容**: Rails Tutorialの痕跡なし（一般的なパスワードリセットメール）

## まとめ

### 変更が必要な箇所

1. **ページタイトル**: `"Ruby on Rails Tutorial Sample App"` → 独自のアプリ名に変更
2. **ヘッダーロゴ**: `"sample app"` → 独自のアプリ名に変更
3. **フッター**: Rails TutorialへのリンクとMichael Hartlへのリンクを削除または変更
4. **ホームページ**: Rails Tutorialへの言及とRailsロゴを削除または変更
5. **Aboutページ**: Rails Tutorialの説明を独自のアプリ説明に変更
6. **Helpページ**: Rails Tutorialへのリンクを独自のヘルプページに変更
7. **Contactページ**: Rails Tutorialへの言及を削除
8. **メールテンプレート**: `"Sample App"` を独自のアプリ名に変更

### 外部リンク

以下の外部リンクがRails Tutorial関連として残っています：
- `https://railstutorial.jp/`
- `https://railstutorial.jp/help`
- `https://railstutorial.jp/contact`
- `https://railstutorial.jp/#ebook`
- `https://railstutorial.jp/screencast`
- `https://news.railstutorial.org/`
- `https://www.michaelhartl.com/`
- `https://rubyonrails.org/`（Railsロゴへのリンク）
