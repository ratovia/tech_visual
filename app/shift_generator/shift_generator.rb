class ShiftGenerator
  DATE_TIME = 24
  def initialize()
    @users = import_user
    # 必要リソースを定義する
    # TODO @req(必要リソース)はテーブルからとってくる。
    @req = [ 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 1 , 2 , 2 , 2 , 2 , 2 , 2 , 3 , 2 , 2 , 1 , 0 , 0 ] #0時〜23時
    # @sum(確定シフトの合計)
    @shift_sum = [ 0 ] * DATE_TIME
  end

  def parseTohour(time)
    Time.zone.parse(time).strftime("%H").to_i
  end

  def parseTohourmin(time)
    Time.zone.parse(time).strftime("%H:%M").to_i
  end

  # 3人のユーザを作成する 
  # 後にUserモデルからとってくる。
  def import_user
    @users = [
      { 
        id: 1,
        name: "John",
        attendance_at: "2019-11-16 10:00:00",
        leaving_at: "2019-11-16 20:00:00",
        shift_in_at: nil,
        shift_out_at: nil
      },
      { 
        id: 2,
        name: "Kevin",
        attendance_at: "2019-11-16 12:00:00",
        leaving_at: "2019-11-16 22:00:00",
        shift_in_at: nil,
        shift_out_at: nil
      },
      { 
        id: 3,
        name: "Cacy",
        attendance_at: "2019-11-16 18:00:00",
        leaving_at: "2019-11-16 22:00:00",
        shift_in_at: nil,
        shift_out_at: nil
      }
    ]
  end
    
  # チェックテストメソッド　必要リソース == 確定シフトの合計となっていること
  def check
    DATE_TIME.times do |i| 
      return false if @req[i] != @shift_sum[i] 
    end
    return true
  end

  # 出勤時間をuser[:array]に格納する。
  # TODO この処理をしなくて済むようにする or user[:array]にアタッチするのをやめる。
  def attendance_method
    @users.each do |user|
      user[:array] = convertPeriod(parseTohour(user[:attendance_at]), parseTohour(user[:leaving_at]))
      p user[:array]
    end
    p @req
  end

  # attendance_at: "2019-11-16 12:00:00",
  # leaving_at: "2019-11-16 22:00:00",
  # 上記フォーマットを配列に変換する。
  # [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
  def convertPeriod(attend,leave)
    array = [ 0 ] * DATE_TIME
    flag = false
    array.each_with_index do |data, i|
      if i == attend
        flag = true
      elsif i == leave
        flag = false
      end 
      array[i] = flag ? 1 : 0
    end
    array
  end

  # 出勤しているユーザから必要リソース人数抽出する。
  def find_assign_users(req,i)
    assign_user = []
    @users.each do |user|
      if user[:array][i] == 1
        assign_user << user
      end
    end
    assign_user.sample(req) # sampleメソッドは、配列からランダムで引数の数取り出す。
  end

  # シフト生成メソッド(シフトのルールベースから生成する)
  def generate_by_rule_base
    @req.each_with_index do |req,i|
      if req > @shift_sum[i]
        assign_user = find_assign_users(req, i)
        assign_user.each do |user|
          if user[:shift_in_at] == nil
            user[:shift_in_at] = Time.zone.strptime((i).to_s, '%H')
            user[:shift_out_at] = Time.zone.strptime((i+1).to_s, '%H')
          else
            user[:shift_out_at] = Time.zone.strptime((i+1).to_s, '%H')
          end
        end
        @shift_sum[i] += assign_user.length 
      end
    end
    p @shift_sum 
  end

  # 各ユーザのシフトを表示する。
  def display_shift
    line = "---------------"
    @users.each do |user|
      p line
      p "◇#{user[:name]}さんの出勤"
      p "#{parseTohour(user[:attendance_at])}〜#{parseTohour(user[:leaving_at])}"
      p "◇#{user[:name]}さんのシフト"
      p "#{parseTohourmin(user[:shift_in_at])}〜#{parseTohourmin(user[:shift_out_at])}"
    end
    p line
  end

  # ShiftGenerator.main
  def main
    attendance_method # 出勤時間を配列に格納する。
    generate_by_rule_base
    p check ? "シフト完了" : "シフト失敗"
    display_shift
  end
end