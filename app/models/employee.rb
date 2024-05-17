class Employee < ApplicationRecord
  # Virtual attribute to hold user's CPF for validation
  attr_accessor :user_cpf

  # Associations
  belongs_to :user
  belongs_to :farm

  # Validations
  validates :farm_id, presence: true
  validates :farm_id, uniqueness: { scope: :user_id, message: "já tem esse funcionário" }
  validates :user_id, :user_cpf, presence: true
  validate :valid_cpf

  # Custom validation method to validate user's CPF
  def valid_cpf
    unless farm.nil?
      errors.add(:user_cpf, :invalid_cpf, message: 'Inválido') unless CPF.valid?(user_cpf)
      errors.add(:user_cpf, :invalid_cpf, message: 'não cadastrado') unless User.find_by(cpf: user_cpf)
      errors.add(:user_cpf, :invalid_cpf, message: 'não é possível se cadastrar') unless user_cpf != farm.user.cpf
    end
  end
end
