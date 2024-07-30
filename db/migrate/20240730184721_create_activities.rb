class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.date :date_start
      t.date :date_end
      t.text :description
      t.string :name
      t.string :type
      t.string :area
      t.integer :forecast_days
      t.text :resources
      t.string :place
      t.references :farm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
