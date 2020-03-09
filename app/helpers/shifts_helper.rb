module ShiftsHelper
  # IN user, date
  # [nil,nil,0,0,1,1,2,2,2,nil,nil]など
  # その日のシフトを1つの配列にして、アサインしてる時間帯にはworkrole_idが入る
  def shifts_to_one_array(user, day)
    array = [nil] * Settings.DATE_TIME
    # 出勤してる時間を0で埋める
    if user.attendances.on_thisday(day).present?
      attendance_at = user.attendances.on_thisday(day).attendance_at
      leaving_at    = user.attendances.on_thisday(day).leaving_at
      array.each_with_index do |clock, index|
        array[index] = 0 if index >= attendance_at && index < leaving_at
      end
    end
    user_shifts = user.shifts.on_thisday(day)
    # シフトのある時間にworkrole_idを入れる
    if user_shifts
      user_shifts.each do |shift|
        shift_in  = shift.shift_in_at.hour
        shift_out = shift.shift_out_at.hour
        # 14-22時シフトなら、14~21にworkrole_idが入る
        shift_in.upto(shift_out - 1) { |is_shift| array[is_shift] = shift.work_role_id }
      end
    end
    array
  end

  # Shiftsのインスタンス群を時間ごとのアサイン数に変換する
  def shifts_count_to_ary(shifts)
    ary = [0] * Settings.DATE_TIME
    shifts.each do |shift|
      shift_out = shift.shift_out_at.hour == 0 ? 24 : shift.shift_out_at.hour
      # アサインされるべき時間で配列を作る
      assign = [*shift.shift_in_at.hour..shift_out - 1]
      # aryのindex＝時間帯の要素を+1する
      assign.each { |clock| ary[clock] += 1 }
    end
    ary
  end

  # ユーザーごとのシフト1行(tdタグ*24)を作る
  def user_shifts_td(user, day, is_shift, shift_in_at)
    if shift_in_at < 8 # 8時より前
      content_tag(:td, '', class: 'hidden')
    else
      if is_shift == nil # 出勤してない時
        content_tag(:td)
      elsif is_shift == 0 # 出勤してるがworkrole_idが0の時
        content_tag(
          :td,
          '',
          class: 'no_workrole js-update_shift',
          'data-workrole-id': is_shift,
          'data-shift-in-at': shift_in_at
        )
      else # 出勤しててworkrole_idが0以外の時
        content_tag(
          :td,
          '',
          class: 'color_shift-data js-update_shift',
          'data-workrole-id': is_shift,
          'data-shift-in-at': shift_in_at
        )
      end
    end
  end
end
