import "regent"

-- assignment to partitions

task my_task(r : region(int))
where reads writes(r) do
  -- something
end

task main()
  var r = region(ispace(ptr, 10), int)

  var t = 0
  var t_final = 100
  -- What you have to write today:
  -- while t < t_final do
  --   var p = partition(equal, r, ispace(int1d, 2))
  --
  --   var need_repartition = false
  --   while not need_repartition do
  --     for i = 0, 2 do
  --       my_task(p[i])
  --     end
  --
  --     need_repartition = does_need_repartition()
  --     t += 1
  --   end
  -- end

  var p = partition(equal, r, ispace(int1d, 2))
  while t < t_final do
    for i = 0, 2 do
      my_task(p[i])
    end

    if does_need_repartition() then
      p = partition(equal, r, ispace(int1d, 2))
    end

    t += 1
  end


end
