class ShiftGenerator
  def initialize(users, workroles)
    @users = users
    @workroles = workroles
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

  def shift_evaluation(shift)
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
    shift[:evaluation] = (-count + count_of_attendance_time) / count_of_attendance_time
  end

  def sum_evaluation(sum_hash, required_hash)
    shortage_count = 0.0;
    sum_hash[:array].each_with_index do |sum, i|
      shortage_count += 1 if required_hash[:array][i] > sum
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
  def find_assign_users(this_day, time, req, attendances)
    assign_user = attendances.map do |attendance|
      # 0 : 出勤しているが、シフトインしていない状態(workrole未割り当てな状態)
      attendance[:user_id] if attendance[:array][time] == 0   
    end.compact
    assign_user.sample(req) # sampleメソッドは、配列からランダムで引数の数取り出す。
  end

  # シフト生成メソッド(シフトのルールベースから生成する)
  def generate_by_rule_base(this_day, workrole, attendances, required)
    sum = [0] * Settings.DATE_TIME
    required.each_with_index do |req, time|
      if req > sum[time]
        find_assign_users(this_day, time, req, attendances).map do |user_id|
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
