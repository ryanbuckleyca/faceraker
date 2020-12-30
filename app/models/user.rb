class User < ApplicationRecord
  has_many :subscriptions
  has_many :groups, through: :subscriptions
  geocoded_by :address, :if => :address_changed?
  after_initialize :geocode, :if => :new_record?
end
