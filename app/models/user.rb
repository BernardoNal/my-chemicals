class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable

  # Associations
  has_many :employees # , dependent: :destroy
  # has_many :employee_farms, through: :marm, source: :farm VER DEPOIS
  has_many :farms, dependent: :destroy
  has_many :storages, through: :farms
  has_many :approved_carts, class_name: 'Cart', foreign_key: 'approver_id'
  has_many :requestor_carts, class_name: 'Cart', foreign_key: 'requestor_id'

  # Validations
  validates :cpf, uniqueness: true
  validates :cpf, :first_name, :last_name, presence: true
  validate :valid_cpf


  def valid_cpf
    return if CPF.valid?(cpf)

    errors.add(:cpf, :invalid_cpf, message: 'Inválido')
  end

  def farmer?
    farms.any?
  end

  def admin?
    is_admin
  end

  def full_name
    (first_name+" "+last_name).capitalize
  end
end
