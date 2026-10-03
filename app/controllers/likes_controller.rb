# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :logged_in_user

  # @return [void]
  def create
    @micropost = Micropost.find(params[:micropost_id])
    like = current_user.likes.find_or_initialize_by(micropost: @micropost)
    authorize like
    begin
      like.save! unless like.persisted?
    rescue ActiveRecord::RecordNotUnique
      # A concurrent request already created this user's like.
    end
    respond_to_change
  end

  # @return [void]
  def destroy
    like = Like.find(params[:id])
    authorize like
    @micropost = like.micropost
    like.destroy!
    respond_to_change
  end

  private

  # @return [void]
  def respond_to_change
    respond_to do |format|
      format.html { redirect_back_or_to(root_path, status: :see_other) }
      format.turbo_stream { render :update }
    end
  end
end
