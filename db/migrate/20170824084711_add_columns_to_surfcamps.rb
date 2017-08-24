class AddColumnsToSurfcamps < ActiveRecord::Migration[5.0]
  def change
    add_column :surfcamps, :price_per_night_per_person, :integer
    add_column :surfcamps, :capacity, :integer
  end
end
