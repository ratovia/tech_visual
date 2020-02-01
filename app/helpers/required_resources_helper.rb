module RequiredResourcesHelper
  # RequiredResourcesのインスタンス群を時間ごとの必要数に変換する
  def resources_count_to_ary(required_resources)
    ary = ([0] * Settings.DATE_TIME).map.with_index do |_ele, i|
      count = 0
      # aryの中で、index(＝時間)がclock_atと一致する要素へcountの数値分足し合わせる
      required_resources.each do |rr|
        count += rr.count if rr.clock_at == i
      end
      count
    end
  end
end
