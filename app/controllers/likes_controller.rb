class LikesController < ApplicationController
  before_action :set_user, only: %i[ new edit update destroy ]

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def like_params
  end
end
