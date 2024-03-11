class RemoveRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :role, :interger
  end
end
