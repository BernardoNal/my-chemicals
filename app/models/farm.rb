class Farm < ApplicationRecord
  belongs_to :user
  has_many :storages, dependent: :destroy
  has_many :carts, through: :storages
  has_many :employees

  validates :name, :size, :cep, presence: true
end
