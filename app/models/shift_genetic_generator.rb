class ShiftGeneticGenerator
  MAX_GENOM_LIST = 180
  SELECT_GENOM = 60
  INDIVIDUAL_MUTATION = 0.05
  GENOM_MUTATION = 0.08
  MAX_GENERATION = 100


  def initialize

  end

  # 選択関数
  # in: 遺伝子リスト
  # out: エリート遺伝子リスト
  def select()
    # ソートしてエリート遺伝子を選択する
  end

  # 交叉関数
  # in: エリート遺伝子A、エリート遺伝子B
  # out: 子遺伝子複数
  def crossover()
    # 遺伝子の要素ごとにどちらかをランダムに採用する
    # 子を複数作成する
  end


  # 突然変異関数
  # in: 遺伝子リスト
  # out: 遺伝子リスト
  def mutation
    # 遺伝子の要素各々をINDIVIDUAL_MUTATIONの確率でランダムに変化させる
    # 遺伝子自体をGENOM_MUTATIONの確率でランダムに変化させる
  end

  # 評価関数
  # in: 遺伝子リスト
  # out: 評価(0.00 ~ 1.00)
  def evaluation
    # 遺伝子の要素各々を評価する
    # 制約達成度を評価する
    # 必要リソース充足を評価する
  end

  # 遺伝的アルゴリズム
  # in: 期間
  # out: シフトインスタンスの配列
  def generate
    # 期間を受け取って期間分繰り返す
    # current_genomsに現在の世代の遺伝子データを格納
    current_genoms = MAX_GENOM_LIST.map { sg.generate()}
    # MAX_GENERATIONの数だけ繰り返す
    # MAX_GENOM_LISTの数だけ繰り返す
    # それぞれの遺伝子を評価する
    # current_genomsから選択し、elite_genomsに格納する
    # elite_genomsから交叉して子を作成し、progeny_genomsに格納する
    # 次世代の遺伝子を決める
    # current_genoms、elite_genoms、progeny_genomsをそれぞれ突然変異させる
    # この世代の最小、最大、平均などをを出力する
    # 最大値が1.00になった場合、MAX_GENERATIONに到達した場合終了
    #
    # 遺伝子からShiftインスタンスを生成する
  end
end
