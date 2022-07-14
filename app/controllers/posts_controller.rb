class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]
  before_action :authenticate_user!
  
  def index
    @posts = Post.includes(:user, :comments, :likes).all.order(id: :desc)
    @post = current_user.posts.build
  end

  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
    if @post.user.id == current_user.id
      render :edit
    else
      redirect_to :root, alert: "Not authorized to edit another user's posts."
    end
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
<<<<<<< HEAD
        @post.broadcast_prepend_to 'post_feed', locals: { post: @post, current_user: current_user }, target: 'post_feed'
=======
        @post.broadcast_prepend_to 'updates_feed', locals: { post: @post, current_user: current_user }, target: 'post_feed'
>>>>>>> feature/css
        format.html { redirect_to :root, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    return unless @post.user.id == current_user.id

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to :root, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    return unless @post.user.id == current_user.id

    @post.destroy

    respond_to do |format|
      format.html { redirect_to :root, notice: "Post was successfully removed." }
      format.turbo_stream { flash.now[:notice] = 'Post removed!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Strong parameters
  def post_params
    params.require(:post).permit(:content)
  end
end
