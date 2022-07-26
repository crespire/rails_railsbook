module Attachable
  extend ActiveSupport::Concern

  MAX_FILE_SIZE = 2_097_152 # 2MB

  included do
    def attachment_type_allowed
      rich_text_content.body.attachments do |attachment|
        errors.add(:content_type, 'not supported, only images.') unless attachment.image?
      end
    end

    def attachment_size_allowed
      rich_text_content.body.attachments do |attachment|
        errors.add(:size, 'too large, 2MB or less.') unless attachment.byte_size <= MAX_FILE_SIZE
      end
    end
  end
end
