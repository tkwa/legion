import "regent"

-- like repartition test, but with a higher-order function

-- required extensions:
-- tasks with other tasks as arguments (is this a thing already?)
-- tasks with functions as arguments

task my_task(r : region(int))
where reads writes(r) do
  -- something
end

-- runs task t on region r with initial partition pi,
-- repartitioning condition f
-- would be cleaner if didn't have to specify subtype of region 5 times
task do_with_repartition(r: region(int),
                         t: task(region(int))
                         f: {region(int)} -> {bool}
                         pi: task(region(int)))
where reads writes(r) do
  -- implementation
end


task main()
  var r = region(ispace(ptr, 10), int)

  do_with_repartition(r, my_task, does_need_repartition)
end
