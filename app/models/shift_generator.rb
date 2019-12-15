class ShiftGenerator
  # TODO　定数としてconfigに入れる
  DATE_TIME = 24

  def initialize(users,workroles)
    @@users = users
    @@workroles = workroles
  end

  # "2019-11-16 10:00:00" => "10"
  def string2hour(time)
    Time.zone.parse(time).strftime("%H")
  end

  # "2019-11-16 10:00:00" => "10:00"
  def string2hourmin(time)
    Time.zone.parse(time).strftime("%H:%M")
  end

  #  "Sat, 07 Dec 2019 10:00:00 UTC +00:00" => "10:00"
  def time2hourmin(time)
    time.strftime("%H:%M")
  end

  # チェックテストメソッド　必要リソース == 確定シフトの合計となっていること
  def check
    DATE_TIME.times do |i| 
      return false if @req[i] != @shift_sum[i] 
    end
    return true
  end

  # 出勤時間をuser[:attend_array]に格納する。
  # TODO この処理をしなくて済むようにする or user[:attend_array]にアタッチするのをやめる。
  def attendance_method(day,user)
    array = convert_attendance_to_array(user.attendances.where(day: date))
  end

  # attendance_at: "2019-11-16 12:00:00",
  # leaving_at: "2019-11-16 22:00:00",
  # 上記フォーマットを配列に変換する。
  # [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
  def convert_attendance_to_array(id,attend,leave)
    array = [ 0 ] * DATE_TIME
    flag = false
    array.each_with_index do |data, i|
      flag = true if i == attend
      flag = false if i == leave
      array[i] = flag ? 1 : 0
    end
    {user_id: id, array: array}
  end

  # 出勤しているユーザから必要リソース人数抽出する。
  def find_assign_users(req,i)
    assign_user = @@users.map{|user| user if user[:attend_array][:array][i] == 1 }
    assign_user.compact.sample(req) # compactメソッドは、配列からnilを削除 # sampleメソッドは、配列からランダムで引数の数取り出す。
  end

  # シフト生成メソッド(シフトのルールベースから生成する)
  def generate_by_rule_base
    array = []
    @req.each_with_index do |req,i|
      if req > @shift_sum[i]
        find_assign_users(req, i).map do |user|
          hash = {user_id: user.id, workrole: }
          if hash[:shift_in_at] == nil
            hash[:shift_in_at] = Time.zone.strptime(("#{i}:00").to_s, '%H:%M')
            hash[:shift_out_at] = Time.zone.strptime(("#{i+1}:00").to_s, '%H:%M')
          else
            hash[:shift_out_at] = Time.zone.strptime(("#{i+1}:00").to_s, '%H:%M')
          end
          # TODO シフト合計の該当を探して1たす
          @shift_sum[i] += 1 
          array << hash
        end
      end
    end
    array
  end

  def sum_method(date, workrole)
    {date: date, workrole: workrole, array: [ 0 ] * DATE_TIME}
  end

  def require_method(date, workrole)
    array = []
    # TODO 必要リソースのmodelからデータを取ってきて配列を作る
    {date: date, workrole: workrole, array: array}
  end

  # シフト生成メソッド
  # TODO 期間を受け取る
  def generate()
    # TODO シフト作成する期間でループする
    date = Date.today
    # TODO mapメソッドにする
    @reqs = []
    @sums = []
    @@workroles.each do |workrole|
      @reqs << require_method(date,workrole)
      @sums << sum_method(date,workrole)
    end
    # TODO mapメソッドにする
    @attendance = []
    @@users.each do |user|
      @attendances << attendance_method(date,user)
    end
    @shifts = generate_by_rule_base
    {check: check, shift: @shifts}
  end
end