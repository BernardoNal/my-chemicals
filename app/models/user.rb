class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :farms
  has_many :storages, through: :farms
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
