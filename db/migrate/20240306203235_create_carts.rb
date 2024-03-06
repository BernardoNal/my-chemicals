class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :storage, null: false, foreign_key: true
      t.date :date_move
      t.boolean :approved

      t.timestamps
    end
  end
end
