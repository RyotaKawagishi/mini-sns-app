module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 永続的セッションのためにユーザーをデータベースに記憶し、かつcookiesを作成
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    # 一時セッションが存在
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # 存在しない(永続セッションにログイン)
    elsif (user_id = cookies.encrypted[:user_id])
      user =  User.find_by(id: user_id)
      # cookiesのトークンで認証
      if user &.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # # 現在ログイン中のユーザーを返す（いる場合）
  # def current_user
  #   if session[:user_id]
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   end
  # end

  # ユーザーがログインしていればtrue
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil   # 安全のため
  end
end
