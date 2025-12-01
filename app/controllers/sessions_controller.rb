class SessionsController < ApplicationController
  # @return [void]
  def new
  end

  # @return [void]
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # ログイン認証（sessionが存在）
    if @user && @user.authenticate(params[:session][:password])
      # アカウント有効化の確認
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new", status: :unprocessable_entity
    end
  end

  # @return [void]
  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
