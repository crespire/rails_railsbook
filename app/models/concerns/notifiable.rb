module Notifiable
  extend ActiveSupport::Concern

  included do
    attr_reader :notification

    after_create do
      notification_details
      broadcast_replace_later_to([@notification[:target].name, 'notifications'],
                                 partial: 'notifications/link',
                                 locals: { user: @notification[:target], update: false },
                                 target: "#{@notification[:target].class.to_s.downcase}_#{@notification[:target].id}_notify_count")
    end

    before_destroy do
      notification_details
      # Have to use non-async here because we destroy the resource after this callback.
      broadcast_replace_to([@notification[:target].name, 'notifications'],
                                 partial: 'notifications/link',
                                 locals: { user: @notification[:target], update: true },
                                 target: "#{@notification[:target].class.to_s.downcase}_#{@notification[:target].id}_notify_count")
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
      @notification[:message] = user.name.to_s

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
