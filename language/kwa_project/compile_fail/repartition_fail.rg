import "regent"

-- assignment to partitions

task my_task(r : region(int))
where reads writes(r) do
  -- something
end

task main()
  var r = region(ispace(ptr, 10), int)

  var p = partition(equal, r, ispace(int1d, 2))


  -- error here; partition is is being assigned to a different type of partition
  p = partition(disjoint, r, ispace(int1d, 2))
end
