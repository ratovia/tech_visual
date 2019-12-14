class WorkRole < ApplicationRecord
  # associations
  has_many :required_resources
  has_many :shifts

  # validates
  validates :name, presence: true

end
