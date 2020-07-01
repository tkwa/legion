import "regent"

-- This field space type has privileges over a region.
fspace t {
  reads writes r : region(int),
}

task new_t(size : int)
  var s = region(ispace(ptr, size), int)
  return t { r = s }
end

task main()
  var x = new_t(10) -- x is a field space

  -- This will work with a naive implementation.
  -- var xr = x.r
  -- xr[0] = 3
  -- xr[1] = 42

  -- Naively the two accesses of x.r get different types
  -- (types are parametrized over regions)
  -- so the mapping of x.r to its pointer is performed twice, causing an error.
  -- Consider ensuring mapping of references
  -- is done only once inside a given task. Requires making them the same type.
  x.r[0] = 3
  x.r[1] = 42

  -- Ideally, the mapping is still only done once per task here.
  var y = id(x)
  y.r[2] = 1337
end
