class Cart < ApplicationRecord
  # Associations
  belongs_to :storage
  belongs_to :approver, class_name: 'User', foreign_key: 'approver_id'
  belongs_to :requestor, class_name: 'User', foreign_key: 'requestor_id'
  has_many :cart_chemicals, dependent: :destroy
  has_many :chemicals, through: :cart_chemicals

  # Validations
  validates :storage_id, :requestor_id, :approver_id, presence: true
end
