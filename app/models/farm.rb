class Farm < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :storages, dependent: :destroy
  has_many :carts, through: :storages
  has_many :cart_chemicals, through: :carts
  has_many :chemicals, through: :cart_chemicals
  has_many :employees, dependent: :destroy

  # Validations
  validates :name, :size, :cep,:user_id, presence: true
end
