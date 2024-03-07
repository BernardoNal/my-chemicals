class Farm < ApplicationRecord
  belongs_to :user
  has_many :storages, dependent: :destroy
  has_many :carts, through: :storages

  validates :name, :size, :cep, presence: true
end
