class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :surfcamp
  has_many :occupancies
end
