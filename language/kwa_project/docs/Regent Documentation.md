# Current type system

The type system of the version of Regent I will formalize differs from the type system for the Legion programming model described in [oopsla2013] in the following ways:

- Regent syntax is built over Terra, allowing Lua metaprogramming
- Task types exist separately from function types. Functions are lightweight; tasks are not first-class.
- Can only reduce by a few primitive functions, not by any function/task
- Can iterate through all items in a region using index spaces
- Regions are homogeneous (all pointers are to ints or bools)
- Can create regions on the fly
- Can index arbitrary subregions of a partition (e.g. `p[expr]`)
- Regions have fields; a task can have field-specific privileges
- In oopsla2013, there are region relations with a region-relation type $$\exists r_1 \dots r_n.T \text{ where } \Omega.$$ In Legion region-relations are realized as field spaces.

Incomplete operational semantics for this idealized version of Regent are in development. However, the type system actually implemented in Regent as of June 2020 is more complicated due to implementation details. It differs from the described features in the following ways:

- Some dependent partitioning features from [dpl2016] are implemented; some are not
- Partitions can have an arbitrary number of regions (not fixed at compile-time).

# Formalization

## Functions and tasks

Tasks take regions, field spaces, primitives as arguments, and return primitives. Functions also exist, and unlike regions have no special properties.

\[T-Function]

$$\frac{\begin{align*}
& e = \lambda x_1 \dots x_n.e'
\\& \Gamma, \Phi, \Omega \vdash \forall x_i \ x_i : T
\\& \Gamma, \Phi, \Omega \vdash e' : T
\end{align*}}{
\Gamma, \Phi, \Omega \vdash e : T
}$$

## Reduction

One can only reduce by a few, specified operators; this is a restriction compared to oopsla2013

```
\phi ::= reads(r) | writes(r) | reduces_reduceid(r)
reduceid ::= + | * | - | / | min | max
```

## Iteration using index spaces

## Homogeneous regions

The type environment $\Gamma$ is extended to store the type of each region, so that if $r$ is a region, $\Gamma(r)$ is the type pointed to.

We update several rules from oopsla2013, notably T-Read, T-Write, T-UpRgn, T-DnRgn.

\[T-Read]

$$\frac{
\begin{array}{l}
\Gamma, \Phi, \Omega \vdash e_{1}: T_1 @\left(r_{1}, \ldots, r_{n}\right) \\
\forall i. \Gamma(r_i) = T_1 \\
\forall i. \text { reads }\left(r_i \right) \in \Phi^{*}
\end{array}
}{
\Gamma, \Phi, \Omega \vdash e : T
}$$

TODO: write other rules

## Dynamic region creation

No change needed because types are already parametrized over regions.

## Arbitrary partition indexing

Can be implemented as a simple rule. There is no type-checking that the thing being indexed is a partition, because partition is not its own type

## Field-specific privileges

`r` in the $\Phi$ definition now means either a region or a field of a region.

## Region relations -> field spaces

See [[Regent Extensions]].

# Proving soundness

We will partially extend the proofs of soundness provided in oopsla2013 and dpl2016 to this extended type system...

[dpl2016]: https://legion.stanford.edu/pdfs/dpl2016.pdf

