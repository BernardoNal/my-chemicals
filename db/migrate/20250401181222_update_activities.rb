class UpdateActivities < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :name, :string
    change_column_null :activities, :activity_type, false
    change_column_null :activities, :area, false
  end
end
