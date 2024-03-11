class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.boolean :manager
      t.boolean :invite
      t.references :user, null: false, foreign_key: true
      t.references :farm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
