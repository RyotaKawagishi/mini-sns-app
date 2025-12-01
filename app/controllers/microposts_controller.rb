class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  # @param micropost_params [Hash] マイクロポストパラメータ
  # @return [void]
  def create
    @micropost = current_user.microposts.build(micropost_params)
    authorize @micropost
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  # @param id [Integer] マイクロポストID
  # @return [void]
  def destroy
    @micropost = Micropost.find(params[:id])
    authorize @micropost
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end
  
  private

    # @return [Hash] 許可されたマイクロポストパラメータ
    def micropost_params
        params.require(:micropost).permit(:content, :image, :in_reply_to)
    end
end