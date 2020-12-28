class Group < ApplicationRecord
  has_many :posts
  belongs_to :subscription
  has_many :users, through: :subscription
end
