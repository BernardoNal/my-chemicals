class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Associations
  has_many :employees # , dependent: :destroy
  # has_many :employee_farms, through: :marm, source: :farm VER DEPOIS
  has_many :farms, dependent: :destroy
  has_many :storages, through: :farms

  # Validations
  validates :cpf, uniqueness: true
  validates :cpf, :first_name, :last_name, presence: true
  validate :valid_cpf

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def valid_cpf
    return if CPF.valid?(cpf)

    errors.add(:cpf, :invalid_cpf, message: 'Inválido')
  end

  def farmer?
    farms.any?
  end
end
