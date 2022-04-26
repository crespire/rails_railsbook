class Friendship < ApplicationRecord
  belongs_to :requestor, class_name: :user
  belongs_to :receiver, class_name: :user
end
