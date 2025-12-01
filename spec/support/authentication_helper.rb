# frozen_string_literal: true

module AuthenticationHelper
  # テストユーザーとしてログインする
  # @param user [User] ログインするユーザー
  # @param password [String] パスワード（デフォルト: "password"）
  # @param remember_me [String] ログイン状態を保持するか（デフォルト: "1"）
  # @return [void]
  def log_in_as(user, password: "password", remember_me: "1")
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end

