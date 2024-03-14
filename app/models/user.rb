class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # validates :first_name, :last_name, :address, :cpf, presence: true
  has_many :employees
  # has_many :employee_farms, through: :marm, source: :farm VER DEPOIS

  has_many :farms

  has_many :storages, through: :farms
  validates :cpf, uniqueness: true
  validates :cpf, cpf: { message: 'Sua mensagem de validação' }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def farmer?
    farms.any?
  end
end
