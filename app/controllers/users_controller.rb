class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  before_action :authenticate_user!

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /search
  def search

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
