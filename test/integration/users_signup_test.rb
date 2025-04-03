require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    # ユーザー情報が無効の場合はユーザー登録ボタンを押してもユーザーが作成されないこと
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: {name: "",
                                       email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "bar" } }
        
    end
    assert_response :unprocessable_entity
    assert_template "users/new"

    # エラーが正しく表示されていること
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
    assert_select 'div#error_explanation'
  end

  # ユーザー登録成功時のテスト
  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # リダイレクト先のshowが正しく表示されること
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.blank?

    # 登録後に自動ログインしていること
    assert is_logged_in?
  end
end
