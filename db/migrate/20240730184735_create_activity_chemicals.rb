class CreateActivityChemicals < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_chemicals do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :chemical, null: false, foreign_key: true
      t.float :quantity

      t.timestamps
    end
  end
end
