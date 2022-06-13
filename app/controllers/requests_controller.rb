class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create]
  before_action :set_request, only: %i[update destroy]

  def create
    @request = current_user.sent_requests.build(request_params)

    if @request.save
      # Do stuff
    end
  end

  def destroy
    @request = current_user.sent_requests.find(params[:id])
    if @request.destroy
      #do stuff
    end
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
    params.require(:request).permit(:friend_id, :user_id)
  end
end
