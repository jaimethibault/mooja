class Surfcamp < ApplicationRecord
  has_many :rooms, dependent: :nullify
  has_many :bookings, dependent: :nullify

  validates :name, presence: true
  validates :address, presence: true
end
