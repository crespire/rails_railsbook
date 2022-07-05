class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @new = current_user.notifications.unseen
    @old = current_user.notifications.seen
  end
end
