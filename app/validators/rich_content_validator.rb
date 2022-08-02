class RichContentValidator < ActiveModel::Validator
  MAX_FILE_SIZE = (1024 * 1024) * 5 # 5MB

  def validate(record)
    record.errors.add(:content, 'can not be blank.') unless record.content.body.to_plain_text.present?
    record.errors.add(:attachment_type, 'not supported, only image uploads are allowed.') unless record.content.body.attachments.all?(&:image?)
    record.errors.add(:attachment_size, 'too large, file must be 5MB or less.') unless record.content.body.attachments.all? { |attachment| attachment.byte_size <= MAX_FILE_SIZE }
  end
end
