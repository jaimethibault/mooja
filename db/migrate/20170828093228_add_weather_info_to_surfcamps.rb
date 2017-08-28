class AddWeatherInfoToSurfcamps < ActiveRecord::Migration[5.0]
  def change
    add_column :surfcamps, :waves_period, :float
    add_column :surfcamps, :water_temp, :float
    add_column :surfcamps, :air_temp, :float
    add_column :surfcamps, :weather_desc, :string
  end
end
