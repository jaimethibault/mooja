class Order < ApplicationRecord
  monetize :amount_cents  # or :amount_pennies
end
