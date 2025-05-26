class ChangeEmployeeForeignKeyOnResponsibles < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :responsibles, :employees
    add_foreign_key :responsibles, :employees, on_delete: :nullify
  end
end
