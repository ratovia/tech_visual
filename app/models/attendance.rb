class Attendance < ApplicationRecord
  # associations
  belongs_to :user

  # validates
  validates :date, :attendance_at, :leaving_at, presence: true
end
