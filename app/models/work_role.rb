class WorkRole < ApplicationRecord
  # associations
  has_many :required_resources, dependent: :destroy
  has_many :shifts
  has_many :assignables
  has_many :users, through: :assignables


  # validates
  validates :name, presence: true

end
