class Group < ApplicationRecord
  has_many :posts
  has_one :subscription
  has_many :users, through: :subscription
end
