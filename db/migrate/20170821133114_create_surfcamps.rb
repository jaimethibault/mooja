class CreateSurfcamps < ActiveRecord::Migration[5.0]
  def change
    create_table :surfcamps do |t|
      t.string :name
      t.text :description
      t.integer :rating
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
