class Shift < ApplicationRecord
  # scope
  scope :on_thisday, ->(day) { where(shift_in_at: day.all_day) }

  # associations
  belongs_to :user
  belongs_to :work_role

  # validates
  validates :shift_in_at, :shift_out_at, presence: true

  class << self
    # genomsを受け取ってshiftインスタンスを生成する
    def build_from_genoms(genoms)
      # 返り値に使うShiftインスタンス格納用配列
      shift_instances = []
      genoms.each do |genom|
        genom[:shifts].each do |shift|
          # 日付(Date型)とユーザー1人分のgenomをbuild_from_user_genomに渡す
          shift_instances << Shift.build_from_user_genom(genom[:this_day].to_date, shift)
        end
      end
      shift_instances.flatten
    end

    # 日付(Date型)とuser_genomを受け取ってshiftインスタンスを生成する
    def build_from_user_genom(date, user_genom)
      # 返り値用の配列
      user_shifts = []
      # shiftsからuser_idを拾い、nilを除外する
      shift_info = { user_id: user_genom[:user_id] }
      user_genom[:array].each_with_index { |ele, i| shift_info[i] = ele if ele }
      # シフトイン時間算出用の変数
      hour = 0
      shift_info.each_with_object({}).each_with_index do |(obj), i|
        # 0はuser_id, 1はuser_nameなのでスキップ
        next if i < 2
        if obj[1] == shift_info[obj[0]+1] # 今のworkroleと次のworkroleが一緒だったら
          hour += 1
        else # それ以外、つまりシフトイン時間が確定したら
          # work_role_id=0 は学習時間のため、変数を初期化して次へ
          hour = 0 and next if obj[1] == 0
          # 確定情報からシフトインスタンスに必要な情報を作成
          hour += 1
          shift_attributes = {
            user_id: shift_info[:user_id],
            work_role_id: obj[1],
            shift_in_at: "#{date} #{obj[0] + 1 - hour}:00:00",
            shift_out_at: "#{date} #{obj[0] + 1}:00:00",
          }
          # シフトイン時間を初期化
          hour = 0
          user_shifts << Shift.new(shift_attributes)
        end
      end
      user_shifts
    end

  end
end
