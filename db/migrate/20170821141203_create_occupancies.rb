class CreateOccupancies < ActiveRecord::Migration[5.0]
  def change
    create_table :occupancies do |t|
      t.integer :price
      t.integer :pax_nb
      t.references :booking, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
