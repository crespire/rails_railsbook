class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[update destroy]

  def index; end

  def create
    @request = current_user.sent_requests.build(request_params)
    @request.save
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
    @request = current_user.all_requests.find { |r| r.id == params[:id].to_i }
  end

  # Strong Params
  def request_params
    params.require(:request).permit(:friend_id, :user_id)
  end
end
