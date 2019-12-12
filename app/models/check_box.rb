class CheckBox < ApplicationRecord
  # associations
  belongs_to :user

  # validates
  validates :name, presence: true
end
