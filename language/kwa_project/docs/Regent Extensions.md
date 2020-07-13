# Current type system

The type system of the version of Regent I will formalize differs from the type system for the Legion programming model described in [oopsla2013] in the following ways:

- Regent syntax is built over Terra, itself a superset of Lua.
- Task types exist separately from function types. Functions are lightweight; tasks are not first-class.
- Can only reduce by a few primitive functions, not by any function/task
- Can iterate through all items in a region using index spaces
- Regions are homogeneous (all pointers are to ints or bools)
- Can create regions on the fly
- Can index arbitrary subregions of a partition (e.g. `p[expr]`)
- Regions have fields; a task can have field-specific privileges
- In oopsla2013, there are region relations with a region-relation type $$\exists r_1 \dots r_n.T \text{ where } \Omega.$$ In Legion region-relations are realized as field spaces.

Incomplete operational semantics for this idealized version of Regent are in development. However, the type system actually implemented in Regent as of June 2020 is more complicated due to implementation details. It differs from the ideal features in the following ways:

- Some dependent partitioning features are not implemented.
- Partitions can have an arbitrary number of subregions, in contrast to the `T-Partition` rule in oopsla2013 where ???

# Extensions to type system

## Tasks with privileged-region and task arguments

```
task_type ::= task({T*}, return_types)
privileged_region ::= privileges* region(T)
privileges ::= reads | writes | reduces + | reduces * | ...
privileged_fspace ::= privileges* fs
```

$$%TODO: write formal semantics$$

Tasks can now have task arguments, allowing for higher-order tasks. This feature will be most useful in commutative fold operations. In other operations, the task overhead will make higher-order functions inefficient. If subtasks are not independent, parallelization will not happen, further reducing efficiency. Tasks with function arguments are beyond the scope of this document.

Regions can now be declared with privileges. Tasks can be passed privileged-region arguments, as an alternate, more flexible way of specifying privileges. A task may read a region `r` if it intrinsically possesses the `read` privilege, or if `reads(r)` is in the task header; similarly for writing. When a region is passed without specifying its privileges, it is assumed to possess no intrinsic privileges, maintaining backwards compatibility.

Limitations:

- Tasks are still not first-class; in particular, a task cannot generate or return tasks.
- We're not looking at privilege inference yet, but it is a future possibility.

## Region and fspace assignment

Assignment of regions and field spaces is now legal. A field space must be reassigned to a value of the same type. A region must be reassigned to a value of the same type. Recall that newly created regions are always a new type, and types are parametrized over regions, thus making newly created field spaces a new type; therefore, no nontrivial assignments can be made without further extensions.

### Formalization

$$%TODO: write formal semantics$$
$$%TODO Think about what properties are in the physical region store Z and whether this can be combined with S from oopsla2013$$

Keep a store $Z$ that maps logical to physical regions. Upon encountering a region `x.r` within a field space `f`, the compiler does the following:
- If `(x.r, p)` is in the $Z$ store, the result is a pointer to `p`
- Otherwise, map `x.r` to the pointer `p` and add `x.r,p`  to $Z$.

Keep a second store $R$ that stores which logical region variables map to which logical region references. This ensures the mapping from `x.r` to its pointer is done exactly once, at the first occurrence of `x.r`.

## Field space region privileges

```lua
-- This field space type has privileges over a region.
fspace t {
  reads writes r : region(int),
}
```

Field space types are extended to include privileges. Field space types still must be declared at top-level.

### Formalization

\[T-Fspace2]

$$\frac{\begin{align*}
& T_{fs} = fspace\_t(\Omega, s_1, \dots, s_n, t_1, \dots, t_n)
	&\text{field space type}
\\& M,L,H,S,C \vdash \forall i \exists r_i \quad  x_i : prreg(r_i) = s_i &\text{region arguments}
\\& M,L,H,S,C \vdash \forall j \quad  y_i : t_i &\text{fields}
\\& \Omega[\dots] \subseteq \Omega^* &\text{constraint closure}
\\& ... % TODO add constraints
\end{align*}}{
M,L,H,S,C \vdash fspace(x_1, \dots, x_k, y_1, \dots, y_l) : T_{fs}
}$$

When a field space type declaration has privilege $P$, we attach $P$ to the fspace type $\phi$.

When a function $f$ is called and reads a region $r$ which is part of a field space $t$, $f$ must have the $reads(t)$ privilege, and $t$ must have the $reads(r)$ privilege. Same is true for writing.

When a task taking a region/fspace argument returns a region/fspace, it is assumed to be a different type from any of its arguments. Therefore, the following causes a compile error because the compiler cannot show that it is safe (see `fspace_region_privileges_alias.rg`); future work will include the ability to infer when a task returns an alias or subregion of its argument.

```
task main()
  var x = new_t(10)
  var y = id(x) -- identity task
  f(y)
end
regentlib.start(main)
```

## Partition assignment

Assignment of partitions is now allowed. The new value of the partition must be of the same region and type (e.g. `equal`, `disjoint`, ...) as the old value.

Internally, the store $S$ also keeps a map from partition variables to their values, which is updated on assignment.

See `repartition.rg` for a positive example and `repartition_fail.rg` for a negative example.


# Proofs

[oopsla2013]: https://legion.stanford.edu/pdfs/oopsla2013.pdf
[flua]: https://scholarworks.sjsu.edu/cgi/viewcontent.cgi?article=1386&context=etd_projects
