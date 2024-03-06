class CreateStorages < ActiveRecord::Migration[7.1]
  def change
    create_table :storages do |t|
      t.references :farm, null: false, foreign_key: true
      t.string :name
      t.string :size
      t.integer :capacity

      t.timestamps
    end
  end
end
