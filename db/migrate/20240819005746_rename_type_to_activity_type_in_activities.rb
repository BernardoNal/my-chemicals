class RenameTypeToActivityTypeInActivities < ActiveRecord::Migration[7.1]
  def change
    rename_column :activities, :type, :activity_type
  end
end
