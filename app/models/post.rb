class Post < ApplicationRecord

  belongs_to :group
  geocoded_by :location, :if => :address_changed?
  after_validation :geocode
end
