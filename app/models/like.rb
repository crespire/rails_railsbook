class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user, class_name: :User, foreign_key: :liked_by

  validates :liked_by, presence: true
end
