module ShiftsHelper
  DATE_TIME = 24
  def shift_time_to_array(shift)
    array = [false] * DATE_TIME
    array.each_with_index do |_ary, i|
      array[i] = true if i >= str2hour(shift[:shift_in_at]) && i < str2hour(shift[:shift_out_at])
    end
    array
  end

  def str2hour(time)
    Time.zone.parse(time.to_s).strftime("%H").to_i
  end
end
