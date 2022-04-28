class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :redirect?

  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path(next: request.fullpath), notice: 'Please log in first.'
    end
  end

  private

  def redirect?
    params['next'].present?
  end
end