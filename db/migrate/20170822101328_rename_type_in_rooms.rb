class RenameTypeInRooms < ActiveRecord::Migration[5.0]
  def change
    rename_column :rooms, :type, :category
  end
end
