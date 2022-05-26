class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_post, only: %i[new, create]
  before_action :authenticate_user!

  def new
    @comment = @post.comments.build
  end

  def edit
    if @comment.user.id == current_user.id
      render :edit
    end
  end

  def create
    @comment = @post.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to :root, notice: 'Comment added!' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    return unless @comment.user.id == current_user.id

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to :root, notice: 'Comment updated!' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    return unless @comment.user.id == current_user.id

    @comment.destroy

    respond_to do |format|
      format.html { redirect_to :root, notice: 'Comment deleted!' }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
