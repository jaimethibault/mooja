class CreateDiscounts < ActiveRecord::Migration[5.0]
  def change
    create_table :discounts do |t|
      t.integer :discounted_price
      t.datetime :limit_offer_date
      t.datetime :discount_starts_at
      t.datetime :discount_ends_at
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
