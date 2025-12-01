class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # @return [void]
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  # @return [void]
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # @return [void]
  def new
    @user = User.new
  end

  # @return [void]
  def create
    @user = User.new(user_params)
    # 保存に成功すればデータベースに保存し、showへ
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new", status: :unprocessable_entity
    end
  end

  # @return [void]
  def edit
    @user = User.find(params[:id])
  end
  
  # @return [void]
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end


  # @return [void]
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  # @return [void]
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  # @return [void]
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,)
    end

    # beforeフィルタ

    # 正しいユーザーかどうか確認
    # @return [void]
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    # 管理者かどうか確認
    # @return [void]
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end

end
