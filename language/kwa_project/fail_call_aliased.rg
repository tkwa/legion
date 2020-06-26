import "regent"

task f(r : region(int), s : region(int))
where reads writes(r, s) do
end

task main()
  var r = region(ispace(ptr, 5), int)
  f(r, r) -- Error: arguments 1 and 2 interfere
end
regentlib.start(main)
