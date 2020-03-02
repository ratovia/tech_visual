class Assignable < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :work_role

  # validations
  validates :user_id, uniqueness: { scope: [:work_role_id]  }
end
