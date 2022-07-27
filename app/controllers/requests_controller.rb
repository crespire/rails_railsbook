class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[update destroy]

  def index; end

  def create
    @request = current_user.sent_requests.build(request_params)
    return unless @request.save

    @request.notify
  end

  def update
    return unless params[:accept].present?

    @request.accept_request
  end

  def destroy
    return unless @request

    @request.destroy
  end

  private

  def set_request
    @request = Request.find(params[:id])
    raise 'Injection detected.' unless @request.friend == current_user || @request.user == current_user
  end

  # Strong Params
  def request_params
    params.require(:request).permit(:friend_id, :user_id)
  end
end
