class User < ApplicationRecord
  has_many :subscriptions
  has_many :groups, through: :subscriptions
end
