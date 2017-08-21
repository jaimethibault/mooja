class Surfcamp < ApplicationRecord
  has_many :rooms
  has_many :bookings
end
