class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @posts = Post.includes(:user).all
  end

  def create
  end

  def update
  end

  def new
  end

  private

  # Strong parameters
  def post_params
  end
end
