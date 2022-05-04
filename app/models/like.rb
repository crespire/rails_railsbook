class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user, foreign_key: :liked_by

  validates :liked_by, presence: true
  validates :likeable_type, presence: true
  validates :likeable_id, presence: true
end
