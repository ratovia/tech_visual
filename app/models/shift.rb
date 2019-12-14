class Shift < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :work_role

  # validates
  validates :shift_in_at, :shift_out_at, presence: true

end
