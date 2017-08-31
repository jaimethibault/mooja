class AddAirportCodeToSurfcamps < ActiveRecord::Migration[5.0]
  def change
    add_column :surfcamps, :airport_code, :string
  end
end
