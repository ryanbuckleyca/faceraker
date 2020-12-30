class Post < ApplicationRecord
  belongs_to :group
  geocoded_by :location, :if => :location_changed?
  before_save :geocode
end
