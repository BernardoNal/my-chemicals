# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

require 'csv'

require "cpf_cnpj"

Chemical.destroy_all

csv_file = Rails.root.join('db/data', 'my_csv_file.csv')
a = 0
CSV.foreach(csv_file, headers: true) do |row|
  Chemical.create!(
    product_name: row['Produto'],
    compound_product: row['DS_INGREDIENTE_ATIVO'],
    type_product: row['CLASSE_AGRONOMICA'],
    area: row['NO_CULTURA'],
    measurement_unit: row['NO_UNIDADE_MEDIDA'],
    amount: row['Amount'].presence || [1, 5, 10, 20, 20, 20, 20, 20].sample
  )
  a += 1
  puts "Product #{a} created..." if (a % 100).zero?
end

User.create!(
  email: "henrique@email.com",
  password: '123456',
  first_name: 'Henrique',
  last_name: 'Dias',
  address: 'quintal do espeto',
  cpf: CPF.generate
)


Farm.create!(name: 'Sol Nascente', size: '500 ha', cep: '49075220', user_id: 1)

Storage.create!(name: "Galpão principal", size: '20 m2', capacity: 1000, farm_id: 1)
Storage.create!(name: "Galpão da laranja", size: '10 m2', capacity: 400, farm_id: 1)


# Chemical.create!(product_name: "Crucial", compound_product: "Glifosato", type_product: 'Herbicida', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)
# Chemical.create!(product_name: "N400", compound_product: "Nitrogenio", type_product: 'Adubo Foliar', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)
# Chemical.create!(product_name: "Atrazina Nortox 500 SC", compound_product: "Atrasina", type_product: 'Herbicida', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)
# Chemical.create!(product_name: "Vorax", compound_product: "Ácido L-Glutâmico", type_product: 'Bio-Fertilizante', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 1)
# Chemical.create!(product_name: "Pumma", compound_product: "Mix de Nutrientes", type_product: 'Fertilizante Mineral', area: 'Milho,Laranja,Soja', measurement_unit: 'KG', amount: 25)
# Chemical.create!(product_name: "Lower 7", compound_product: "Ureia", type_product: 'Redutor de pH', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 5)
