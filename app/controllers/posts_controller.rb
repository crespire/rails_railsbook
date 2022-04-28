class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user).all
  end
end
