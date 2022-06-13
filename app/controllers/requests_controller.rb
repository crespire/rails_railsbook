class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create]
  before_action :set_request, only: %i[update destroy]

  def create
  end

  def update
  end

  def destroy
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
