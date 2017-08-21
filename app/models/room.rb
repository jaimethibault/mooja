class Room < ApplicationRecord
  belongs_to :surfcamp
  has_many :discounts
end
