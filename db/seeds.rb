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
  # begin
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
  # rescue => e
  #   puts "Error on line #{a + 1}: #{e.message}"
  # end
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

Storage.create!(name: "Galpão principal", size: '20 m2', farm_id: 1)
Storage.create!(name: "Galpão da laranja", size: '10 m2', farm_id: 1)

# Criação de activities
  activity1 = Activity.create!(
    date_start: Date.today - 7,
    date_end: Date.today - 1,
    description: "Plantio de soja na área norte da fazenda",
    name: "Plantio de Soja",
    activity_type: "Plantio",
    area: "Norte",
    forecast_days: 6,
    resources: "Tratores, sementes de soja",
    place: "Campo A",
    farm_id: 1
  )

  activity2 = Activity.create!(
    date_start: Date.today - 15,
    date_end: Date.today - 10,
    description: "Irrigação da área sul para preparo do solo",
    name: "Irrigação do Sul",
    activity_type: "Irrigação",
    area: "Sul",
    forecast_days: 5,
    resources: "Sistema de irrigação, energia elétrica",
    place: "Campo B",
    farm_id: 1
  )

# Criação de activity_chemicals
  ActivityChemical.create!(
    activity_id: activity1.id,
    chemical_id: 1,
    quantity: 20.5
  )

  ActivityChemical.create!(
    activity_id: activity2.id,
    chemical_id: 2,
    quantity: 10.0
  )

# Chemical.create!(product_name: "Lower 7", compound_product: "Ureia", type_product: 'Redutor de pH', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 5)
