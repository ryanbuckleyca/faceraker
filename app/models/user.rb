class User < ApplicationRecord
  has_many :subscriptions
  has_many :groups, through: :subscriptions
  geocoded_by :address, :if => :address_changed?
  before_save :geocode
end
