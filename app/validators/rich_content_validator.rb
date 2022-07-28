class RichContentValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:content, 'can not be blank.') unless record.content.body.to_plain_text.present?
  end
end
