# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'csv'

Chemical.destroy_all

csv_file = Rails.root.join('db/data', 'my_csv_file.csv')

CSV.foreach(csv_file, headers: true) do |row|
  Chemical.create!(
    product_name: row['Produto'],
    compound_product: row['DS_INGREDIENTE_ATIVO'],
    type_product: row['CLASSE_AGRONOMICA'],
    area: row['NO_CULTURA'],
    measurement_unit: row['NO_UNIDADE_MEDIDA'],
    amount: [1, 5, 10, 20, 20, 20, 20, 20].sample
  )
  puts "Product created..."
end
