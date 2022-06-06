class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[index]

  # Show index of requests for current user
  def index
    @requests = @user.all_requests
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Strong Params
  def request_params

  end
end
