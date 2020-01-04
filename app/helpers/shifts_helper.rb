module ShiftsHelper
  def shift_time_to_array(shift)
    array = [false] * Settings.DATE_TIME
    array.each_with_index do |_ary, i|
      array[i] = true if i >= str2hour(shift[:shift_in_at]) && i < str2hour(shift[:shift_out_at])
    end
    array
  end

  def str2hour(time)
    Time.zone.parse(time.to_s).strftime("%H").to_i
  end
  
  def display_day_and_wday(day)
    wd = ["日", "月", "火", "水", "木", "金", "土"]
    day.strftime("%d日 (#{wd[day.wday]})")
  end
end
