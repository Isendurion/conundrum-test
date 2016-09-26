a = [1,2,3,4,5,6,7,90]

a.map!.with_index do |value, index|
  value == a.last ? true : value+1 == a[index+1]
end

p a.all?
