class CreateFarms < ActiveRecord::Migration[7.1]
  def change
    create_table :farms do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :size
      t.string :cep
      t.string :complement
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
