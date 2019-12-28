class ShiftGenerator
  # TODO　定数としてconfigに入れる
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


  # attendance_at: "2019-11-16 12:00:00",
  # leaving_at: "2019-11-16 22:00:00",
  # 上記フォーマットを配列に変換する。
  # [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
  def attendance_method(this_day, user)
    attendance = user.attendances.find_by(date: this_day)
    array = [0] * Settings.DATE_TIME
    array.each_with_index do |_ary, i|
      array[i] = 1 if i >= attendance[:attendance_at] && i < attendance[:leaving_at]
    end
    { user_id: user.id, array: array }
  end

  # 出勤しているユーザから必要リソース人数抽出する。
  def find_assign_users(req, i, attendances)
    assign_user = attendances.map do |attendance|
      attendance[:user_id] if attendance[:array][i] == 1
    end.compact
    assign_user.sample(req) # sampleメソッドは、配列からランダムで引数の数取り出す。
  end

  # シフト生成メソッド(シフトのルールベースから生成する)
  def generate_by_rule_base(this_day, workrole, attendances, required)
    sum = [0] * Settings.DATE_TIME
    shift_array = @@users.map { |user| Shift.new(user_id: user.id, work_role_id: workrole.id) }
    required.each_with_index do |req, i|
      if req > sum[i]
        find_assign_users(req, i, attendances).map do |user_id|
          shift_instance = shift_array.map { |shift| shift if shift.user_id == user_id}
          shift_instance = shift_instance.compact[0]
          if shift_instance.shift_in_at.nil?
            shift_instance.shift_in_at = Time.zone.strptime(("#{i}:00").to_s, '%H:%M')
            shift_instance.shift_out_at = Time.zone.strptime(("#{i+1}:00").to_s, '%H:%M')
          else
            shift_instance.shift_out_at = Time.zone.strptime(("#{i+1}:00").to_s, '%H:%M')
          end
          sum[i] += 1
        end
      end
    end
    @checker = false unless check(required,sum)
    # 複数人のshiftが入った配列
    shift_array
  end

  # 必要リソースのデータ取得
  def require_method(this_day,workrole)
    # TODO this_dayからWhat_dayをだす。
    workrole.required_resources.where(what_day: RequiredResource.on_(this_day)).map { |h| h[:count] }  
  end

  # シフト生成メソッド
  # TODO 期間を受け取る
  def generate
    # TODO シフト作成する期間でループする
    this_day = Time.current
    attendances = @@users.map { |user| attendance_method(this_day, user) }
    @checker = true
    @@workroles.each do |workrole|
      @shifts = generate_by_rule_base(
        this_day, # どの日の
        workrole, # どの場所に
        attendances, # 誰が出勤していて
        require_method(this_day, workrole) #必要リソースが
      )
    end
    @shifts.map(&:save) if @checker
    { check: @checker, shift: @shifts }
  end
end