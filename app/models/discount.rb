class Discount < ApplicationRecord
  belongs_to :surfcamp

  validates :discounted_price, presence: true
  validates :limit_offer_date, presence: true
  validates :discount_starts_at, presence: true
  validates :discount_ends_at, presence: true
end
