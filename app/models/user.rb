class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :first_name, :last_name, :address, :cpf, :role, presence: true

  has_many :farms
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
