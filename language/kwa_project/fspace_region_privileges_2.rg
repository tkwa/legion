import "regent"


-- This field space type has privileges over a region.
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
  var y = id(x) -- identity function
  -- y is of the same field space type as x (in fact, is alias of x)
  -- and so carries the same region privileges.
  f(y)
  var sum = g(y)
end
regentlib.start(main)
