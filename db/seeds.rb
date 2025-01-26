series = Series.create

(1..15).to_a.shuffle.each do |value| 
  series.items.create(value:)
end
