class CreateResponsibles < ActiveRecord::Migration[7.1]
  def change
    create_table :responsibles do |t|
      t.string :name
      t.references :employee, foreign_key: true
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
