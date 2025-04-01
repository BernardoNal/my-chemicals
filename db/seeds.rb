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

# Arrays para armazenar dados de exemplo
  activity_types = ["Plantio", "Colheita", "Irrigação", "Fertilização", "Pulverização"]
  areas = ["Norte", "Sul", "Leste", "Oeste", "Central"]
  places = ["Campo A", "Campo B", "Campo C", "Campo D", "Campo E"]
# Criação de 10 activities
10.times do |i|
  activity = Activity.create!(
    date_start: Date.today - (i * 10 + 7),
    date_end: Date.today - (i * 10 + 1),
    description: "#{activity_types[i % activity_types.size]} na área #{areas[i % areas.size]}",
    activity_type: activity_types[i % activity_types.size],
    area: "#{activity_types[i % activity_types.size]} #{areas[i % areas.size]}",
    forecast_days: rand(1..10),
    resources: "Recursos #{i + 1}",
    place: places[i % places.size],
    farm_id: 1
  )

  # Criação de activity_chemicals para cada atividade
  ActivityChemical.create!(
    activity_id: activity.id,
    chemical_id: (i % 5) + 1, # Alterna entre IDs de químicos 1 a 5
    quantity: rand(5.0..50.0).round(2) # Quantidades aleatórias
  )
end

Responsible.create!([
  {
    name: "Carlos Oliveira",

    activity_id: 1  # Substitua com um ID válido de um registro em activities
  },
  {
    name: "Fernanda Souza",
    activity_id: 2
  },
  {
    name: "Rafael Silva",
    activity_id: 3
  },
  {
    name: "Juliana Costa",
    activity_id: 4
  },
  {
    name: "Mariana Almeida",
    activity_id: 5
  }
])


# Chemical.create!(product_name: "Lower 7", compound_product: "Ureia", type_product: 'Redutor de pH', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 5)
