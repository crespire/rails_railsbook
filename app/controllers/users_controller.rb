class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  before_action :authenticate_user!

  # GET /users/1 or /users/1.json
  def show; end

  # GET /search
  def search
    return unless params[:query].present?

    @param = params[:query].downcase
    @results = User.where('lower(name) LIKE :query', query: "%#{@param}%").order('RANDOM()')
  end

  private

  # Set user before show action
  def set_user
    @user = User.find(params[:id])
  end
end
