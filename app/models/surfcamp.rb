class Surfcamp < ApplicationRecord
  has_many :rooms
  has_many :bookings
  has_attachment :photo
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
