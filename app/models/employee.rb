class Employee < ApplicationRecord
  # Virtual attribute to hold user's CPF for validation
  attr_accessor :user_cpf

  # Associations
  belongs_to :user
  belongs_to :farm
  has_many :responsibles, dependent: :nullify

  # Validations
  validates :farm_id, presence: true
  validates :farm_id, uniqueness: { scope: :user_id, message: "já tem esse funcionário" }
  validates :user_id, :user_cpf, presence: true
  validate :valid_cpf
  before_destroy :clean_up_responsibles

  # Custom validation method to validate user's CPF
  def valid_cpf
    unless farm.nil?
      errors.add(:user_cpf, :invalid_cpf, message: 'Inválido') unless CPF.valid?(user_cpf)
      errors.add(:user_cpf, :invalid_cpf, message: 'não cadastrado') unless User.find_by(cpf: user_cpf)
      errors.add(:user_cpf, :invalid_cpf, message: 'não é possível se cadastrar') unless user_cpf != farm.user.cpf
    end
  end

  def clean_up_responsibles
   Rails.logger.info ">> CALLBACK: Limpando responsibles do funcionário #{id}"
    puts ">> CALLBACK: Limpando responsibles do funcionário #{id}"
    # Garante que o nome do user ainda está acessível antes do destroy
    nome_usuario = user&.full_name

    responsibles.find_each do |responsible|
        responsible.update!(
          employee_id: nil,
          name: "Ex-#{nome_usuario || 'Funcionário'}"
        )
    end
  end
end
