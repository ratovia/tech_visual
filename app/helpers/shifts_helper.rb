module ShiftsHelper
  def shift_time_to_array(shift)
    array = [false] * Settings.DATE_TIME
    array.each_with_index do |_ary, i|
      array[i] = shift[:work_role_id] if i >= str2hour(shift[:shift_in_at]) && i < str2hour(shift[:shift_out_at])
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

  def shifts_to_one_array(shifts)
    array = [nil] * Settings.DATE_TIME
    shifts.each do |shift|
      shift_time_to_array(shift).each_with_index do |_ary, i|
        array[i] ||= _ary
      end
    end
    array
  end

  # Shiftsのインスタンス群を時間ごとのアサイン数に変換する
  def shifts_count_to_ary(shifts)
    ary = Array.new(24, 0)
    shifts.each do |shift|
      shift[:shift_out_at].hour = 24 if shift[:shift_out_at].hour.zero?
      # アサインされるべき時間で配列を作る
      assign = [*shift[:shift_in_at].hour..shift[:shift_out_at].hour - 1]
      # aryのindex＝時間帯の要素を+1する
      assign.each { |clock| ary[clock] += 1 }
    end
    ary
  end
end
