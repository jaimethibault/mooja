class Occupancy < ApplicationRecord
  belongs_to :booking
  belongs_to :room

  validates :pax_nb, presence: true
   validates :price, presence: true
end
