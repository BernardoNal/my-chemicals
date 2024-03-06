class CreateChemicals < ActiveRecord::Migration[7.1]
  def change
    create_table :chemicals do |t|
      t.string :product_name
      t.string :compound_product
      t.string :type_product
      t.string :hazard
      t.string :area
      t.string :measurement_unit
      t.integer :amount
      t.float :dosage

      t.timestamps
    end
  end
end
