class AddCityToSurfcamps < ActiveRecord::Migration[5.0]
  def change
    add_column :surfcamps, :city, :string
  end
end
