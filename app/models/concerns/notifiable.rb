module Notifiable
  extend ActiveSupport::Concern

  included do
    attr_reader :details

    after_commit do
      set_details
    end

    def notify
      Notification.create(actor: user, notifiable: self, target: @details[:notify_target], message: @details[:message])
    end

    private

    def set_details
      @details ||= Hash.new
      @details[:message] ||= "#{user.name}"

      case self
      when Request
        @details[:notify_target] ||= friend
        @details[:message] += ' sent you a friend request.'
      when Like
        @details[:notify_target] ||= likeable.user
        @details[:message] += " liked your #{likeable_type.downcase}."
      when Comment
        @details[:notify_target] ||= post.user
        @details[:message] += ' commented on your post.'
      else
        raise 'Invalid notify type.'
      end
    end
  end
end
