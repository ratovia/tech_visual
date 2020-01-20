module RequiredResourcesHelper
  # RequiredResourcesのインスタンス群を時間ごとの必要数に変換する
  def resources_count_to_ary(required_resources)
    ary = Array.new(24, 0).map.with_index do |ele, i|
      count = 0
      required_resources.each do |rr|
        count += rr.count if rr.clock_at == i
      end
      count
    end
    ary
  end
end
