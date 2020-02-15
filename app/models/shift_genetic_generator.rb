class ShiftGeneticGenerator
  MAX_GENOM_LIST = 100
  SELECT_GENOM = 10
  INDIVIDUAL_MUTATION = 0.08
  GENOM_MUTATION = 0.05
  ADJACENT_MUTATION = 0.05
  MAX_GENERATION = 100


  def initialize(users, workroles)
    @users = users
    @workroles = workroles
    @sg = ShiftGenerator.new(@users, @workroles)
  end

  # 選択関数
  # in: 遺伝子リスト
  # out: エリート遺伝子リスト
  def select_elite(genoms)
    # ソートしてエリート遺伝子を選択する
    genoms.sort_by! { |h| h[:evaluation]}.pop(SELECT_GENOM)
  end

  # 交叉関数
  # in: エリート遺伝子リスト
  # out: 子遺伝子複数
  def crossover(genoms)
    len = genoms.length
    genoms.shuffle!
    progeny_genoms = []
    # 遺伝子の要素ごとにどちらかをランダムに採用する
    len.times do |i|
      parent = [genoms[i]]
      parent.push(genoms[rand(len)])
      45.times do |_|
        progeny_genom = {
          this_day: parent[0][:this_day], 
          required: parent[0][:required],
          sum: parent[0][:sum],
          shifts: []
        }
        @users.length.times do |user|
          array = [0] * Settings.DATE_TIME
          progeny_genom[:shifts].push({
            user_id: parent[0][:shifts][user][:user_id],
            array: array.map!.with_index { |_, j| parent[rand(2)][:shifts][user][:array][j]}
          })
        end
        progeny_genoms << progeny_genom
      end
      45.times do |_|
        progeny_genom = {
          this_day: parent[0][:this_day],
          required: parent[0][:required],
          sum: parent[0][:sum],
          shifts: []
        }
        @users.length.times do |user|
          array = [0] * Settings.DATE_TIME
          progeny_genom[:shifts].push({
            user_id: parent[0][:shifts][user][:user_id],
            array: array.map!.with_index { |_, j| parent[rand(2)][:shifts][user][:array][j]},
            array: parent[0][:shifts][user][:evaluation] >= parent[1][:shifts][user][:evaluation] ? parent[0][:shifts][user][:array] : parent[1][:shifts][user][:array]
          })
        end
        progeny_genoms << progeny_genom
      end
    end
    progeny_genoms
  end


  # 突然変異関数
  # in: 遺伝子リスト
  # out: 遺伝子リスト
  def mutation(genoms)
    len = @workroles.length
    genoms.each_with_index do |genom, i|
      genom[:shifts].each do |shift|
        # 遺伝子の要素各々をINDIVIDUAL_MUTATIONの確率でランダムに変化させる
        shift[:array].map! { |x| !x.nil? && rand(100) <= INDIVIDUAL_MUTATION * 100 ? rand(len + 1) : x}
        # 遺伝子自体をGENOM_MUTATIONの確率でランダムに変化させる
        if rand(100) <= GENOM_MUTATION * 100
          shift[:array].map! { |x| rand(len + 1) if !x.nil?}
        end
      end
    end
  end

  # 評価関数
  # in: 遺伝子リスト
  # out: 評価(0.00 ~ 1.00)
  def evaluation(genom)
    genom[:shifts].map { |shift| @sg.evaluation(shift) }
    # 遺伝子の要素各々を評価する
    element_sum = 0.0;
    genom[:shifts].map { |shift| element_sum += shift[:evaluation]}
    # 制約達成度を評価する
    # 必要リソース充足を評価する
    genom[:evaluation] = element_sum / genom[:shifts].length
  end

  # 世代の評価を表示する
  def display(genoms, gen)
    min = genoms.min_by { |genom| genom[:evaluation]}
    max = genoms.max_by { |genom| genom[:evaluation]}
    median = genoms.sort_by { |h| h[:evaluation]}[genoms.size/2]

    puts "----- 第#{gen + 1}世代 -----"
    puts "最小値: #{min[:evaluation]}"
    puts "中央値: #{median[:evaluation]}"
    puts "最大値: #{max[:evaluation]}"
  end

  # 遺伝的アルゴリズム
  # in: 期間
  # out: max_genomsのリスト
  def generate(period)
    max_genoms = []
    next_genoms = nil
    # 期間を受け取って期間分繰り返す
    (DateTime.parse(period[:start])..DateTime.parse(period[:finish])).each do |this_day|
      # MAX_GENERATIONの数だけ繰り返す
      @sg.setAttendances(this_day)
      @sg.setRequiredResources(this_day)
      max_genom = nil
      MAX_GENERATION.times do |gen|
        # current_genomsに現在の世代の遺伝子データを格納
        current_genoms = next_genoms || [*0...MAX_GENOM_LIST].map { @sg.generate(this_day)}
        # current_genomsを評価する
        current_genoms.map { |genom| evaluation(genom) }
        # この世代の最小、最大、平均などをを出力する
        display(current_genoms, gen)
        # 最大値が1.00になった場合終了
        max_genom = current_genoms.max_by { |genom| genom[:evaluation]}
        if max_genom[:evaluation] == 1.0
          max_genoms << max_genom
        elsif gen == MAX_GENERATION - 1
          max_genoms << max_genom
        else
          # current_genomsから選択し、elite_genomsに格納する
          elite_genoms = select_elite(current_genoms)
          # elite_genomsから交叉して子を作成し、progeny_genomsに格納する
          progeny_genoms = crossover(elite_genoms).deep_dup
          # elite_genoms、progeny_genomsをそれぞれ突然変異させる
          # 次世代の遺伝子を決める
          mutation(progeny_genoms)
          next_genoms = elite_genoms + progeny_genoms
        end
      end
    end
    max_genoms
  end
end
