# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :logged_in_user

  # @return [void]
  def index
    @search = Search.new(search_params)
    if params[:type] == 'microposts'
      @microposts = search_posts.paginate(page: params[:page], per_page: 20)
    else
      @users = @search.users(policy_scope(User), admin: current_user.admin?).paginate(page: params[:page], per_page: 20)
    end
  end

  private

  # @return [ActiveRecord::Relation]
  def search_posts
    @search.microposts(Micropost.joins(:user).merge(policy_scope(User)))
  end

  # @return [ActionController::Parameters]
  def search_params
    params.permit(:query, :author_id, :from_date, :to_date)
  end
end
