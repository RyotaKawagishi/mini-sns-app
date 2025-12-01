class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include SessionsHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

    # ユーザーのログインを確認する
    # @return [void]
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end

    # Punditの認可エラー時の処理
    # @return [void]
    def user_not_authorized
      flash.clear
      redirect_to root_url, status: :see_other
    end
end
