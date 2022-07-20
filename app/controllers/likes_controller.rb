class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = Like.new(like_params)
    if @like.save
      @like.notify
    else
      flash[:alert] = @like.errors.full_messages.join(', ')
    end
  end

  def destroy
    @like = current_user.likes.find_by(likeable_id: params[:like][:likeable_id], likeable_type: params[:like][:likeable_type])
    @like.destroy
  end

  private

  def like_params
    params.require(:like).permit(:liked_by, :likeable_type, :likeable_id)
  end
end
