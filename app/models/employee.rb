class Employee < ApplicationRecord
  attr_accessor :user_cpf

  belongs_to :user
  belongs_to :farm
end
