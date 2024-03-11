class Employee < ApplicationRecord
  belongs_to :user
  belongs_to :farm
end
