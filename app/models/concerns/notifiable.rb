module Notifiable
  extend ActiveSupport::Concern

  included do
    def set_details
      @details ||= Hash.new

      case self
      when Request
        @details[:notify_target] ||= friend
        @details[:message] ||= "#{user.name} sent you a friend request."
      when Like
        @details[:notify_target] ||= likeable.user
        @details[:message] ||= "#{user.name} liked your #{likeable_type.downcase}."
      when Comment
        @details[:notify_target] ||= post.user
        @details[:message] ||= "#{user.name} commented on your post."
      else
        raise 'Invalid notify type.'
      end
    end

    def notify
      set_details
      Notification.create(actor: user, notifiable: self, target: @details[:notify_target], message: @details[:message])
    end
  end
end
