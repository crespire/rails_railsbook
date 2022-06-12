class Friend < ApplicationRecord
  has_many :requests
  has_many :friends, through: :requests
end
