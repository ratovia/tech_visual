class RequiredResource < ApplicationRecord
  # associations
  belongs_to :work_role

  # validates
  validates :what_day, :clock_at, :count, presence: true
  validates :what_day, numericality: { greater_than_or_equal_to: 1,
                                       less_than_or_equal_to: 14 }
  validates :clock_at, numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 23 }

  def self.on_(this_day)
    first_week_case = [8,9,10,11,12,13,14,15,23,24,25,26,27,28,29,30] # 今週の土曜がこの日付なら今日は1週目
    dif_of_wday_what_day = 2 # wdayとキックオフ後日数との差。例えば日曜はwday=0、キックオフ2日目。
    this_sat = this_day - (this_day.wday - 6).days
    what_day = if first_week_case.include?(this_sat.day)
                 this_day.wday + dif_of_wday_what_day
               else
                 # 2週目の土曜は15日目と計算されてしまうため、その場合は1(次のキックオフ当日)とする
                 this_day == this_sat ? 1 : this_day.wday + dif_of_wday_what_day + 7
               end
    where(what_day: what_day)
  end
end
