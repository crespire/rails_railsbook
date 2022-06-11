class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[index create new]
  before_action :set_request, only: %i[show edit update destroy]

  # Show index of requests for current user
  def index
    @requests = @user.requests.accepted
  end

  def new
    @request = Request.new
  end

  def show
  end

  def create
  end

  def destroy
  end

  # Used to accept friendship, I wonder if we can alias 'update' with 'accept'
  def update
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_request
    @request = Request.find(params[:id])
  end

  # Strong Params
  def request_params
  end
end
