class AddDescriptionToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :description, :string
  end
end
