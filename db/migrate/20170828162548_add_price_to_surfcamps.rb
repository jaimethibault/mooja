class AddPriceToSurfcamps < ActiveRecord::Migration[5.0]
  def change
    add_monetize :surfcamps, :price, currency: { present: false }
  end
end
