module ShiftsHelper
  def display_day_and_wday(day)
    wd = ["日", "月", "火", "水", "木", "金", "土"]
    day.strftime("%d日 (#{wd[day.wday]})")
  end
end
