module Attachable
  extend ActiveSupport::Concern

  included do
    def attachment_type_allowed
      rich_text_content.body.attachments do |attachment|
        errors.add(:content_type, 'not supported, only images.') unless %w[image/jpeg image/png image/gif image/webp image/apng].include? attachment.content_type
      end
    end

    def attachment_size_allowed
      rich_text_content.body.attachments do |attachment|
        errors.add(:size, 'too large, 2MB or less.') unless attachment.byte_size <= 2097152
      end
    end
  end
end