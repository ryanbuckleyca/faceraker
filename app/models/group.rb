class Group < ApplicationRecord
  has_many :posts
  has_many :subscription
  has_many :users, through: :subscription
end
