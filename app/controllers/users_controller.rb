class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :load_user, only: [:show, :edit, :update, :destroy, :following, :followers]

  # @return [void]
  def index
    @users = policy_scope(User).paginate(page: params[:page])
    authorize @users
  end
  
  # @param id [Integer] ユーザーID
  # @return [void]
  def show
    authorize @user
    @microposts = @user.microposts.includes(:user, :likes, image_attachment: :blob).paginate(page: params[:page])
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
    authorize @user
  end
  
  # @param id [Integer] ユーザーID
  # @param user_params [Hash] ユーザーパラメータ
  # @return [void]
  def update
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
    authorize @user
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  # @param id [Integer] ユーザーID
  # @return [void]
  def following
    render_relationships(:following, "Following")
  end

  # @param id [Integer] ユーザーID
  # @return [void]
  def followers
    render_relationships(:followers, "Followers")
  end

  private

    # @return [User] requested user
    def load_user
      @user = User.find(params[:id])
    end

    # @param association [Symbol] relationship association
    # @param title [String] page title
    # @return [void]
    def render_relationships(association, title)
      authorize @user, "#{association}?"
      @title = title
      @users = @user.public_send(association).paginate(page: params[:page])
      render "show_follow"
    end

    # @return [Hash] 許可されたユーザーパラメータ
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,)
    end
end
