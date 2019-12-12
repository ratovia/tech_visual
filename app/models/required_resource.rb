class RequiredResource < ApplicationRecord
  # associations
  belongs_to :work_role

  # enums
  enum what_day: { weekday: 1, holiday: 2, kick_off_weekday: 3, kick_off_holiday: 4 }

  # validates
  validates :what_day, :clock_at, :count, presence: true
end
