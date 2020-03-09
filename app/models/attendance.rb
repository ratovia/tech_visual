class Attendance < ApplicationRecord
  # associations
  belongs_to :user

  # scope
  scope :on_thisday, ->(day) {
    find_by(date: day)
  }

  # validates
  validates :date, :attendance_at, :leaving_at, presence: true
end
