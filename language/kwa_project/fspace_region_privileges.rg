import "regent"

fspace t {
  reads writes r : region(int),
}

task new_t(size : int)
  var s = region(ispace(ptr, size), int)
  return t { r = s }
end

task f(x : t)
where reads writes(x) do -- reads writes(x.r)
  for i in x.t do
    x.t[i] += 1
  end
end

task g(x : t)
where reads(x) do -- reads(x.r)
  var sum = 0
  for i in x.t do
    sum += x.t[i]
  end
  return sum
end

task main()
  var x = new_t(10)
  f(x)
  var sum = g(x)
end
regentlib.start(main)
