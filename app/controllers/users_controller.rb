class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]

  # @return [void]
  def index
    @users = policy_scope(User).paginate(page: params[:page])
    authorize @users
  end
  
  # @param id [Integer] ユーザーID
  # @return [void]
  def show
    @user = User.find(params[:id])
    authorize @user
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # @return [void]
  def new
    @user = User.new
    authorize @user
  end

  # @param user_params [Hash] ユーザーパラメータ
  # @return [void]
  def create
    @user = User.new(user_params)
    authorize @user
    # 保存に成功すればデータベースに保存し、showへ
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new", status: :unprocessable_entity
    end
  end

  # @param id [Integer] ユーザーID
  # @return [void]
  def edit
    @user = User.find(params[:id])
    authorize @user
  end
  
  # @param id [Integer] ユーザーID
  # @param user_params [Hash] ユーザーパラメータ
  # @return [void]
  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  # @param id [Integer] ユーザーID
  # @return [void]
  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  # @param id [Integer] ユーザーID
  # @return [void]
  def following
    @title = "Following"
    @user = User.find(params[:id])
    authorize @user, :following?
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  # @param id [Integer] ユーザーID
  # @return [void]
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    authorize @user, :followers?
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

    # @return [Hash] 許可されたユーザーパラメータ
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,)
    end
end
