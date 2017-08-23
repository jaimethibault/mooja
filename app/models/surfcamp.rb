class Surfcamp < ApplicationRecord
  has_many :rooms, dependent: :nullify
  has_many :bookings, dependent: :nullify
  has_attachment :photo
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :name, presence: true
  validates :address, presence: true
end
