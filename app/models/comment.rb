class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  has_many :likes, as: :likeable
  has_many :comments, as: :commentable

  validates :content, presence: true
end
