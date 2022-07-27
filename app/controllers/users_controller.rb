class UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]
  before_action :authenticate_user!

  # GET /users
  def index
    @results = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  def edit
    @user = current_user
    render 'profile'
  end

  def update
  end

  # GET /search
  def search
    raise 'No search term' unless params[:query].present?

    @param = params[:query].downcase
    @results = User.where('lower(name) LIKE :query', query: "%#{@param}%").order(id: :asc)
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    reset_session
    redirect_to new_user_session_path, notice: "Account deleted.", status: 303
  end

  private

  # Set user before show action
  def set_user
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
end
