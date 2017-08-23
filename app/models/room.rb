class Room < ApplicationRecord
   CATEGORIES = ["dormitory", "private room"]

  belongs_to :surfcamp
  has_many :discounts, dependent: :nullify
  has_many :occupancies, dependent: :nullify

  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :price_per_night, presence: true
  validates :capacity, presence: true
end
