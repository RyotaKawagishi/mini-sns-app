ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    # 指定のワーカー数でテストを並列実行する
    parallelize(workers: :number_of_processors)
    # test/fixtures/*.ymlのfixtureをすべてセットアップする
    fixtures :all
    include ApplicationHelper

    # テストユーザーがログイン中ならtrue
    def is_logged_in?
      !session[:user_id].nil?
    end

    # テストユーザーとしてログインする
    def log_in_as(user)
      session[:user_id] = user.id
    end
  end
end

module ActionDispatch

  class IntegrationTest
  
  # テストユーザーとしてログインする
    def log_in_as(user, password: "password", remember_me: "1")
      post login_path, params: { session: { email: user.email,
                                            password: password,
                                            remember_me: remember_me } }
    end
  end

end