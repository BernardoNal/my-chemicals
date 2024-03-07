# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(
  email: "henrique@email.com",
  password: '123456',
  first_name: 'hen',
  last_name: 'rique',
  address: 'quintal do espeto',
  role: 0,
  cpf: "66699966669"
)

farm1 = Farm.create!(name: 'Sol Nascente', size: '500 ha', cep: '49075220', user_id: 1)
farm2 = Farm.create!(name: 'Sol Nascente', size: '500 ha', cep: '49075220', user_id: 1)

stock1 = Storage.create!(name: "Galpao principal", size: '20 m2', capacity: 1000, farm_id: 1)
stock2 = Storage.create!(name: "Galpao da laranja", size: '10 m2', capacity: 400, farm_id: 1)

cart1 = Cart.create!(date_move: '03/12/2022', approved: true, storage_id: 1)
cart2 = Cart.create!(date_move: '13/12/2022', approved: true, storage_id: 1)
cart3 = Cart.create!(date_move: '15/12/2022', approved: true, storage_id: 1)

chemicals1 = Chemical.create!(product_name: "Crucial", compound_product: "Glifosato", type_product: 'Herbicida', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)
chemicals2 = Chemical.create!(product_name: "N400", compound_product: "Nitrogenio", type_product: 'Adubo Foliar', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)
chemicals3 = Chemical.create!(product_name: "Atrazina Nortox 500 SC", compound_product: "Herbicida", type_product: 'Adubo Foliar', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)

c_chemical = CartChemical.create!(quantity: 10, chemical_id: 1, cart_id: 1)
c_chemica2 = CartChemical.create!(quantity: 10, chemical_id: 2, cart_id: 1)
c_chemica3 = CartChemical.create!(quantity: -5, chemical_id: 2, cart_id: 3)
c_chemica4 = CartChemical.create!(quantity: 10, chemical_id: 3, cart_id: 2)
c_chemica5 = CartChemical.create!(quantity: 10, chemical_id: 2, cart_id: 2)
