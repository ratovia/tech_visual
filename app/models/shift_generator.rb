class ShiftGenerator
  REPEATING_WEIGHT = 0.3
  ASSIGNABLE_WEIGHT = 0.4
  PART_TIMER_WEIGHT = 0.3
  def initialize(users, workroles)
    @users = users
    @workroles = workroles
    @assignable = @users.map { |user| {user_id: user.id, assignable_workroles_ids: user.work_roles.ids}}
    @part_timers_id = @users.map { |user| user.id if user.part_timer? }.compact
  end

  def setAttendances(this_day)
    @attendances = @users.map { |user| attendance_method(this_day, user) }
  end

  def setRequiredResources(this_day)
    @required_resources = []
    @workroles.each do |wr|
      @required_resources << {workrole_id: wr.id, array: require_method(this_day, wr)}
    end
  end

  # Repeating制約の評価
  # in: 1ユーザのシフト
  # out: 評価(0.00 ~ 1.00)
  def repeating_evaluation(shift)
    count = 0.0
    previous_list = []
    # 一度出てきたworkrole_idが連続ではなく再度出現した時にcount 1する
    shift[:array].each_with_index do |ary, i|
      next if ary.nil? || ary == 0
      # 今回の数字がlistにすでにあり、連続ではなかったら
      if previous_list.include?(ary) && ary != shift[:array][i - 1]
        count += 1
      end
      previous_list.push(ary)
    end
    count_of_attendance_time = shift[:array].count { |n| !n.nil? } - 1
    count_of_attendance_time = 1 if count_of_attendance_time < 1
    (-count + count_of_attendance_time) / count_of_attendance_time
  end

  # assignable制約の評価
  # in: 1ユーザのシフト
  # out: 評価(0.00 ~ 1.00)
  def assignable_evaluation(shift)
    error_assignable_count = 0.0
    shift[:array].each_with_index do |ary, i|
      next if ary.nil? || ary == 0
      # 今回の数字(アサインされたworkrole)がassignableではなかったら、エラーカウントを1たす 
      user_assignable = @assignable.find { |as| as[:user_id] == shift[:user_id] } 
      unless user_assignable[:assignable_workroles_ids].include?(ary)
        error_assignable_count += 1
      end
    end
    count_of_attendance_time = shift[:array].count { |n| !n.nil?} - 1
    count_of_attendance_time = 1 if count_of_attendance_time < 1
    (-error_assignable_count + count_of_attendance_time) / count_of_attendance_time
  end

  # part timer制約の評価
  # in: 1ユーザのシフト
  # out: 評価(0.00 ~ 1.00)
  def part_timer_evaluation(shift)
    non_assign_count = 0.0
    return 1.0 unless @part_timers_id.include?(shift[:user_id])
    shift[:array].each_with_index do |ary, i|
      next if ary != 0
      # 今回の数字(アサインされたworkrole)が0(未アサイン)だったら1たす 
      non_assign_count += 1
    end
    count_of_attendance_time = shift[:array].count { |n| !n.nil?} - 1
    count_of_attendance_time = 1 if count_of_attendance_time < 1
    ( -non_assign_count + count_of_attendance_time) / count_of_attendance_time
  end

  # シフト評価関数
  # in: 1ユーザのシフト
  # out: 評価(0.00 ~ 1.00)
  def shift_evaluation(shift)
    # repeating制約(なんども同じworkroleにアサインしない)
    repeating_evaluation = repeating_evaluation(shift)
    # assignable制約
    assignable_evaluation = assignable_evaluation(shift)
    # part_timer制約
    part_timer_evaluation = part_timer_evaluation(shift)

    shift[:evaluation] = repeating_evaluation * REPEATING_WEIGHT + assignable_evaluation * ASSIGNABLE_WEIGHT + part_timer_evaluation * PART_TIMER_WEIGHT
  end

  def sum_evaluation(sum_hash, required_hash)
    shortage_count = 0.0
    sum_hash[:array].each_with_index do |sum, i|
      shortage_count += 1 if required_hash[:array].length > 0 && required_hash[:array][i] > sum
    end
    sum_hash[:evaluation] = (-shortage_count + Settings.DATE_TIME) / Settings.DATE_TIME
  end

  # 該当ユーザの出勤、非出勤を配列に格納する。 
  # in; 日付、ユーザ
  # out: { user_id: ユーザのid ,array: [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, nil, nil] }
  # 出勤=> 0(workrole未割り当て), 非出勤：nil
  def attendance_method(this_day, user)
    attendance = user.attendances.find_by(date: this_day)
    array = [nil] * Settings.DATE_TIME
    if attendance.present?
      array.each_with_index do |_, i|
        array[i] = 0 if i >= attendance[:attendance_at] && i < attendance[:leaving_at]
      end
    end
    { user_id: user.id, user_name: user.name, array: array }
  end

  # 出勤しているユーザから必要リソース人数抽出する。
  # in: 日付、時間、必要リソース、出勤リスト
  # out: アサインされたユーザの配列
  def find_assign_users(this_day, time, req, attendances, workrole)
    assign_user = attendances.map do |attendance|
      # 0 : 出勤しているが、シフトインしていない状態(workrole未割り当てな状態)
      attendance[:user_id] if attendance[:array][time] == 0  && @assignable.find { |as| as[:user_id] == attendance[:user_id]}[:assignable_workroles_ids].include?(workrole.id)
    end.compact
    assign_user.sample(req) # sampleメソッドは、配列からランダムで引数の数取り出す。
  end

  # シフト生成メソッド(シフトのルールベースから生成する)
  def generate_by_rule_base(this_day, workrole, attendances, required)
    sum = [0] * Settings.DATE_TIME
    required.each_with_index do |req, time|
      if req > sum[time]
        find_assign_users(this_day, time, req, attendances, workrole).map do |user_id|
          attendance = attendances.find { |at| at[:user_id] == user_id}
          attendance[:array][time] = workrole.id
          sum[time] += 1
        end
      end
    end
    # TODO メソッドの役割とマッチしないので、あまりここで@req、@sumの値変更はしたくない。
    @req << { workrole: {id: workrole.id, name: workrole.name}, array: required }
    @sum << { workrole: {id: workrole.id, name: workrole.name}, array: sum }
    # 複数人のshiftが入った配列
    attendances
  end

  # 必要リソースのデータ取得
  # in: 日付、workrole
  # out: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  def require_method(this_day,workrole)
    workrole.required_resources.where(what_day: RequiredResource.on_(this_day)).map { |h| h[:count] }  
  end

  # シフト生成メソッド
  # in: 日付
  # out: シフトの一覧
  def generate(this_day)
    @shifts = [], @sum = [], @req = []
    attendances = @attendances.deep_dup
    @workroles.each do |workrole|
      generate_by_rule_base(
        this_day, # どの日の
        workrole, # どの場所に
        attendances, # 誰が出勤していて
        @required_resources.find {|h| h[:workrole_id] == workrole.id } &.fetch(:array) #必要リソースが
      )
    end
    {this_day: this_day,required: @req, sum: @sum, shifts: attendances}
  end
end
