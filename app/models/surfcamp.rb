class Surfcamp < ApplicationRecord
  has_many :rooms
  has_many :bookings
  has_attachment :photo
end
