class AddApproverAndRequestorToCarts < ActiveRecord::Migration[7.1]
  def change
    add_reference :carts, :approver, null: true, foreign_key: { to_table: :users }
    add_reference :carts, :requestor, null: true, foreign_key: { to_table: :users }
  end
end
