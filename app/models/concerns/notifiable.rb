module Notifiable
  extend ActiveSupport::Concern

  included do
    attr_reader :notification

    after_save do
      notification_details
    end

    def notify
      notification_details
      Notification.create(actor: user,
                          target: @notification[:target],
                          notifiable: self,
                          message: @notification[:message])
    end

    private

    def notification_details
      @notification ||= {}
      @notification[:message] ||= user.name.to_s

      case self
      when Request
        @notification[:target] ||= friend
        @notification[:message] += ' sent you a friend request.'
      when Like
        @notification[:target] ||= likeable.user
        @notification[:message] += " liked your #{likeable_type.downcase}."
      when Comment
        @notification[:target] ||= post.user
        @notification[:message] += ' commented on your post.'
      else
        raise 'Invalid notify type.'
      end
    end
  end
end
