class CreateCartChemicals < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_chemicals do |t|
      t.references :chemical, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.float :quantity

      t.timestamps
    end
  end
end
