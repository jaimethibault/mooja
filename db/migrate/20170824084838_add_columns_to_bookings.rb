class AddColumnsToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :total_discounted_price, :integer
    add_column :bookings, :total_original_price, :integer
    add_column :bookings, :pax_nb, :integer
  end
end
