class ShiftGenerator
  def initialize(users, workroles)
    @@users = users
    @@workroles = workroles
  end

  # チェックテストメソッド　必要リソース == 確定シフトの合計となっていること
  def check(req, sum)
    Settings.DATE_TIME.times do |i|
      return false if req[i] != sum[i]
    end
    true
  end

  # 該当ユーザの出勤時間を配列に格納する。 1 => 出勤
  # [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
  def attendance_method(this_day, user)
    attendance = user.attendances.find_by(date: this_day)
    array = [0] * Settings.DATE_TIME
    if attendance.present?
      array.each_with_index do |_ary, i|
        array[i] = 1 if i >= attendance[:attendance_at] && i < attendance[:leaving_at]
      end
    end
    { user_id: user.id, array: array }
  end

  # 該当ユーザが、該当日、時間に未アサインであるか？
  def unassigned?(this_day, time, user_id)
    @shifts.each do |shift|
      next if shift[:user_id] != user_id
      next if shift[:shift_in_at].strftime('%Y-%m-%d') != this_day.strftime('%Y-%m-%d')
      return false if time >= shift[:shift_in_at].strftime('%H').to_i &&
                      time <  shift[:shift_out_at].strftime('%H').to_i
    end
    true
  end

  # 出勤しているユーザから必要リソース人数抽出する。
  def find_assign_users(this_day, time, req, attendances)
    assign_user = attendances.map do |attendance|
      attendance[:user_id] if attendance[:array][time] == 1 && unassigned?(this_day, time, attendance[:user_id])
    end.compact
    assign_user.sample(req) # sampleメソッドは、配列からランダムで引数の数取り出す。
  end

  # シフト生成メソッド(シフトのルールベースから生成する)
  def generate_by_rule_base(this_day, workrole, attendances, required)
    sum = [0] * Settings.DATE_TIME
    shift_array = @@users.map { |user| Shift.new(user_id: user.id, work_role_id: workrole.id) }
    required.each_with_index do |req, time|
      if req > sum[time]
        find_assign_users(this_day, time, req, attendances).map do |user_id|
          shift_instance = shift_array.map { |shift| shift if shift.user_id == user_id}
          shift_instance = shift_instance.compact.last
          if shift_instance.shift_in_at.nil?
            shift_instance.shift_in_at = Time.zone.strptime(this_day.to_s,"%Y-%m-%d").change(hour: time)
            shift_instance.shift_out_at = Time.zone.strptime(this_day.to_s,"%Y-%m-%d").change(hour: time+1)
          elsif shift_instance.shift_out_at.strftime('%H').to_i == time
            shift_instance.shift_out_at = Time.zone.strptime(this_day.to_s,"%Y-%m-%d").change(hour: time+1)
          else
            shift_array << Shift.new(
              user_id: user_id,
              work_role_id: workrole.id,
              shift_in_at: Time.zone.strptime(this_day.to_s,"%Y-%m-%d").change(hour: time),
              shift_out_at: Time.zone.strptime(this_day.to_s,"%Y-%m-%d").change(hour: time+1)
            )
          end
          sum[time] += 1
        end
      end
    end
    # シフト時間が入らなかったShiftインスタンスは排除
    shift_array.keep_if { |shift| shift.shift_in_at? }
    @checker = false unless check(required,sum) 
    # TODO メソッドの役割とマッチしないので、あまりここで@req、@sumの値変更はしたくない。
    @req << { date: this_day, workrole: {id: workrole.id, name: workrole.name}, array: required }
    @sum << { date: this_day, workrole: {id: workrole.id, name: workrole.name}, array: sum }
    # 複数人のshiftが入った配列
    shift_array
  end

  # 必要リソースのデータ取得
  def require_method(this_day,workrole)
    workrole.required_resources.where(what_day: RequiredResource.on_(this_day)).map { |h| h[:count] }  
  end

  # シフト生成メソッド
  def generate(period)
    @shifts = []
    @sum = []
    @req = []
    (DateTime.parse(period[:start])..DateTime.parse(period[:finish])).each do |this_day|
      attendances = @@users.map { |user| attendance_method(this_day, user) }
      @checker = true
      @@workroles.each do |workrole|
        @shifts += generate_by_rule_base(
          this_day, # どの日の
          workrole, # どの場所に
          attendances, # 誰が出勤していて
          require_method(this_day, workrole) #必要リソースが
        )
      end
    end
    @shifts.map(&:save) if @checker
    { check: @checker, shift: @shifts ,sum: @sum, req: @req}
  end
end