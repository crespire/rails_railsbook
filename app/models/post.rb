class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable

  validates :content, presence: true
end
