import "regent"

-- When there is region aliasing in task arguments,
-- and regions are given conflicting privileges (r1 write, r2 read or write)
-- then compiling should fail, see fail_call_aliased.rg
-- Compiling succeeds when no conflicting privileges

-- Implementation: straightforward by tracking refs?

-- This uses the old task-based privileges system, but
-- make sure any extension is compatible with field space region privileges
--
task f(r : region(int), s : region(int))
where reads writes(s) do
end

task g1()
  var r = region(ispace(ptr, 5), int)
  f(r, r)
  -- should detect aliasing and compile
end


task main()
  g1()
end
regentlib.start(main)
