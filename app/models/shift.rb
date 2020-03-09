class Shift < ApplicationRecord
  # scope
  scope :on_thisday, ->(day) { where(shift_in_at: day.all_day) }

  # associations
  belongs_to :user
  belongs_to :work_role

  # validates
  validates :shift_in_at, :shift_out_at, presence: true

  class << self


    def find_user_shift(user, this_day, shifts = Shift.all)
      shifts.map do |shift|
        shift if user.id == shift[:user_id] && this_day.strftime('%Y/%m/%d') == shift[:shift_in_at].strftime('%Y/%m/%d')
      end.compact!
    end

    def build_from_genoms(genoms)
      # 返り値に使うShiftインスタンス格納用配列
      shift_instances = []
      genoms.each do |genom|
        genom[:shifts].each do |shift|
          # shiftsからuser_idを拾い、nilを除外する
          shift_info = { user_id: shift[:user_id] }
          shift[:array].each_with_index { |ele, i| shift_info[i] = ele if ele }
          # シフトイン時間算出用の変数
          hour = 0
          shift_info.each_with_object({}).each_with_index do |(obj), i|
            # 初回はuser_idなのでスキップ
            next if i == 0
            if obj[1] == shift_info[obj[0]+1] # 今のworkroleと次のworkroleが一緒だったら
              hour += 1
            else # それ以外、つまりシフトイン時間が確定したら
              # work_role_id=0 は学習時間のため、変数を初期化して次へ
              hour = 0 and next if obj[1] == 0
              # 確定情報からシフトインスタンスに必要な情報を作成
              hour += 1
              day = genom[:this_day].to_date
              shift_attributes = {
                user_id: shift_info[:user_id],
                work_role_id: obj[1],
                shift_in_at: "#{day} #{obj[0] + 1 - hour}:00:00",
                shift_out_at: "#{day} #{obj[0] + 1}:00:00",
              }
              # シフトイン時間を初期化
              hour = 0
              shift_instances << Shift.new(shift_attributes)
            end
          end
        end
      end
      shift_instances.flatten
    end
  end
end
