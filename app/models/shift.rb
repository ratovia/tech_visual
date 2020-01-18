class Shift < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :work_role

  # validates
  validates :shift_in_at, :shift_out_at, presence: true

  def self.find_user_shift(user, this_day, shifts = Shift.all)
    shifts.map do |shift|
      shift if user.id == shift[:user_id] && this_day.strftime('%Y/%m/%d') == shift[:shift_in_at].strftime('%Y/%m/%d') 
    end.compact!
  end
end
