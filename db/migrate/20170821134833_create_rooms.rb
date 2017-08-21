class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :type
      t.integer :price_per_night
      t.integer :capacity
      t.references :surfcamp, foreign_key: true

      t.timestamps
    end
  end
end
