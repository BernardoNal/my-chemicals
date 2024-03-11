class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # validates :first_name, :last_name, :address, :cpf, :role, presence: true
  has_many :employees
  has_many :employee_farms, through: :employees, source: :farm

  has_many :farms

  has_many :storages, through: :farms
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def farmer?
    farms.any?
  end
end
