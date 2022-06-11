class Request < ApplicationRecord
  belongs_to :requestor, class_name: :User
  belongs_to :receiver, class_name: :User

  scope :accepted, -> { where('accepted = true') }
  scope :pending, -> { where('accepted = false') }
end
