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
  cpf: "66699966669"
)
User.create!(
  email: "jordano@email.com",
  password: '123456',
  first_name: 'jordano',
  last_name: 'rique',
  address: 'quintal do espeto',
  cpf: "66699966669"
)
User.create!(
  email: "lucas@email.com",
  password: '123456',
  first_name: 'lu',
  last_name: 'cas',
  address: 'quintal do espeto',
  cpf: "66699966669"
)
User.create!(
  email: "clara@email.com",
  password: '123456',
  first_name: 'cla',
  last_name: 'ra',
  address: 'quintal do espeto',
  cpf: "66699966678"
)



farm1 = Farm.create!(name: 'Sol Nascente', size: '500 ha', cep: '49075220', user_id: 1)
farm2 = Farm.create!(name: 'Maria da Murta', size: '200 ha', cep: '49075550', user_id: 1)
farm3 = Farm.create!(name: 'Lagoa Escura', size: '600 ha', cep: '49075420', user_id: 2)


employee1 = Employee.create!(manager: false, invite: true, user_id: 4, farm_id: 1)
employee2 = Employee.create!(manager: true, invite: false, user_id: 3, farm_id: 1)

stock1 = Storage.create!(name: "Galpao principal", size: '20 m2', capacity: 1000, farm_id: 1)
stock2 = Storage.create!(name: "Galpao da laranja", size: '10 m2', capacity: 400, farm_id: 1)
stock3 = Storage.create!(name: "Galpao do Rio", size: '5 m2', capacity: 200, farm_id: 2)
stock4 = Storage.create!(name: "Galpao da baixa funda", size: '10 m2', capacity: 400, farm_id: 3)


cart1 = Cart.create!(date_move: '03/12/2022', approved: true, storage_id: 1)
cart2 = Cart.create!(date_move: '13/12/2022', approved: true, storage_id: 1)
cart3 = Cart.create!(date_move: '15/12/2022', approved: true, storage_id: 1)
cart4 = Cart.create!(date_move: '03/12/2022', approved: true, storage_id: 2)
cart5 = Cart.create!(date_move: '13/12/2022', approved: true, storage_id: 3)
cart6 = Cart.create!(date_move: '15/12/2022', approved: true, storage_id: 3)

chemicals1 = Chemical.create!(product_name: "Crucial", compound_product: "Glifosato", type_product: 'Herbicida', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)
chemicals2 = Chemical.create!(product_name: "N400", compound_product: "Nitrogenio", type_product: 'Adubo Foliar', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)
chemicals3 = Chemical.create!(product_name: "Atrazina Nortox 500 SC", compound_product: "Atrasina", type_product: 'Herbicida', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 20)
chemicals4 = Chemical.create!(product_name: "Vorax", compound_product: "Ácido L-Glutâmico", type_product: 'Bio-Fertilizante', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 1)
chemicals5 = Chemical.create!(product_name: "Pumma", compound_product: "Mix de Nutrientes", type_product: 'Fertilizante Mineral', area: 'Milho,Laranja,Soja', measurement_unit: 'KG', amount: 25)
chemicals6 = Chemical.create!(product_name: "Lower 7", compound_product: "Ureia", type_product: 'Redutor de pH', area: 'Milho,Laranja,Soja', measurement_unit: 'L', amount: 5)

c_chemical = CartChemical.create!(quantity: 10, chemical_id: 1, cart_id: 1)
c_chemica2 = CartChemical.create!(quantity: 10, chemical_id: 2, cart_id: 1)
c_chemica3 = CartChemical.create!(quantity: -5, chemical_id: 2, cart_id: 3)
c_chemica4 = CartChemical.create!(quantity: 10, chemical_id: 3, cart_id: 2)
c_chemica5 = CartChemical.create!(quantity: 10, chemical_id: 2, cart_id: 2)


c_chemical = CartChemical.create!(quantity: 10, chemical_id: 4, cart_id: 4)
c_chemica2 = CartChemical.create!(quantity: 10, chemical_id: 5, cart_id: 4)
c_chemica3 = CartChemical.create!(quantity: -5, chemical_id: 4, cart_id: 5)
c_chemica4 = CartChemical.create!(quantity: 10, chemical_id: 6, cart_id: 6)
c_chemica5 = CartChemical.create!(quantity: 10, chemical_id: 6, cart_id: 6)
