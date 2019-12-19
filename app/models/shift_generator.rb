class ShiftGenerator
  # TODO　定数としてconfigに入れる
  DATE_TIME = 24
  def initialize(users, workroles)
    @@users = users
    @@workroles = workroles
  end

  # "2019-11-16 10:00:00" => "10"
  def string2hour(time)
    Time.zone.parse(time).strftime('%H')
  end

  # "2019-11-16 10:00:00" => "10:00"
  def string2hourmin(time)
    Time.zone.parse(time).strftime('%H:%M')
  end

  #  "Sat, 07 Dec 2019 10:00:00 UTC +00:00" => "10:00"
  def time2hourmin(time)
    time.strftime('%H:%M')
  end

  # チェックテストメソッド　必要リソース == 確定シフトの合計となっていること
  def check(req, sum)
    DATE_TIME.times do |i|
      return false if req[i] != sum[i]
    end
    true
  end

  def attendance_method(this_day, user)
    array = convert_attendance_to_array(user.attendances.find_by(date: this_day))
    { user_id: user.id, array: array }
  end

  # attendance_at: "2019-11-16 12:00:00",
  # leaving_at: "2019-11-16 22:00:00",
  # 上記フォーマットを配列に変換する。
  # [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
  def convert_attendance_to_array(attendance)
    array = [0] * DATE_TIME
    flag = false
    array.each_with_index do |data, i|
      flag = true if i == attendance[:attendance_at]
      flag = false if i == attendance[:leaving_at]
      array[i] = flag ? 1 : 0
    end
    array
  end

  # 出勤しているユーザから必要リソース人数抽出する。
  def find_assign_users(req, i, attendances)
    # TODO　mapメソッド化
    assign_user = []
    # TODO 他のshiftがないか確認
    attendances.each do |attendance|
      if attendance[:array][i] == 1
        assign_user << attendance[:user_id]
      end
    end
    assign_user.sample(req) # sampleメソッドは、配列からランダムで引数の数取り出す。
  end

  # シフト生成メソッド(シフトのルールベースから生成する)
  def generate_by_rule_base(this_day, workrole, attendances, required)
    sum = [0] * DATE_TIME
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

  def require_method(this_day,workrole)
    # TODO this_dayからWhat_dayをだす。
    workrole.required_resources.where(what_day: RequiredResource.on_(this_day)).map { |h| h[:count] }  
  end

  # シフト生成メソッド
  # TODO 期間を受け取る
  def generate
    # TODO シフト作成する期間でループする
    this_day = Date.today
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
    @shifts.map(&:save)
    { check: @checker, shift: @shifts }
  end
end