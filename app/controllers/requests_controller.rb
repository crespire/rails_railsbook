class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[destroy]

  def create
    @request = current_user.sent_requests.build(request_params)

    if @request.save
      # Do stuff
    end
  end

  def destroy
    if @request.destroy
      #do stuff
    end
  end

  private

  def set_request
    @request = current_user.sent_requests.find(params[:id])
  end

  # Strong Params
  def request_params
    params.require(:request).permit(:friend_id, :user_id)
  end
end
