class Responsible < ApplicationRecord
  belongs_to :activity
  belongs_to :employee, optional: true

  validates :activity_id, presence: true
  validates :name, presence: true, unless: -> { employee.present? }
end
