class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.all
  end
end
