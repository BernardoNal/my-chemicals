class RemoveCapacityFromStorages < ActiveRecord::Migration[7.1]
  def change
    remove_column :storages, :capacity, :interger
  end
end
