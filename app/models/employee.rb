class Employee < ApplicationRecord
  attr_accessor :user_cpf

  belongs_to :user
  belongs_to :farm

  validates  :farm_id, presence: true

  validate :valid_cpf

  def valid_cpf
    unless CPF.valid?(user_cpf)
      errors.add(:user_cpf, :invalid_cpf, message: 'Inválido')
    end
    unless User.find_by(cpf: user_cpf)
      errors.add(:user_cpf, :invalid_cpf, message: 'Inexistente')
    end
  end
end
