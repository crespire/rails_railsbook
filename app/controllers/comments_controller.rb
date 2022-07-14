class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_parent, only: %i[index new create]
  before_action :authenticate_user!

  def index
    @comments = @post.comments
  end

  def new
    @comment = @post.comments.build
    @comment.user_id = current_user.id
  end

  def edit
    return unless @comment.user.id == current_user.id

    render :edit
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save!
        @comment.notify
        @comment.broadcast_append_to 'updates_feed', locals: { comment: @comment, current_user: current_user }, target: "post_#{@comment.post.id}_comments"
        format.turbo_stream { flash.now[:notice] = 'Comment added!' }
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
      format.turbo_stream { flash.now[:notice] = 'Comment deleted!' }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_parent
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id, :user_id)
  end
end
