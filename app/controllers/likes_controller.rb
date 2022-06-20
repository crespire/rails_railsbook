class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    params[:like][:liked_by] = current_user.id
    @like = Like.new(like_params)
    if @like.save
      flash[:success] = 'Thanks for liking!'
    else
      flash[:alert] = @like.errors.full_messages.join(', ')
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
  end

  private

  def like_params
    params.require(:like).permit(:liked_by, :likeable_id, :likeable_type)
  end
end
