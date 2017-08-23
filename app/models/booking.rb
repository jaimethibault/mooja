class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :surfcamp
  has_many :occupancies, dependent: :nullify

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :status, presence: true

end
