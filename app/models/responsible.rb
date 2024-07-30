class Responsible < ApplicationRecord
  belongs_to :activity
  belongs_to :employee, optional: true

  validates :name, presence: true
end
