class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @posts = Post.includes(:user).all
  end
end
