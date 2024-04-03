class Farm < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :storages, dependent: :destroy
  has_many :carts, through: :storages
  has_many :employees, dependent: :destroy

  # Validations
  validates :name, :size, :cep, presence: true
end
