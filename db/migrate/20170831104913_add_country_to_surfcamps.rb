class AddCountryToSurfcamps < ActiveRecord::Migration[5.0]
  def change
    add_column :surfcamps, :country, :string
  end
end
