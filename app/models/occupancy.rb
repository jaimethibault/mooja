class Occupancy < ApplicationRecord
  belongs_to :booking
  belongs_to :room
end
