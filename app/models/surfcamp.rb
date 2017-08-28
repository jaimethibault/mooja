class Surfcamp < ApplicationRecord
  has_many :discounts, dependent: :nullify
  has_many :bookings, dependent: :nullify
  has_attachments :photos
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :name, presence: true
  validates :address, presence: true
end
