# Discussion with a novice Julia programmer

## Usage

```
              _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: https://docs.julialang.org
   _ _   _| |_  __ _   |  Type "?help" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.6.4 (2018-07-09 19:09 UTC)
 _/ |\__'_|_|_|\__'_|  |  Official http://julialang.org/ release
|__/                   |  x86_64-apple-darwin14.5.0

shell> # cd to the project directory
julia> include("prog2.jl")
281.954466 seconds (813.55 M allocations: 41.693 GiB, 0.99% gc time)
julia> include("prog2A.jl")
  0.072048 seconds (24.97 k allocations: 1.067 MiB)
  0.020722 seconds (48.79 k allocations: 2.316 MiB)
  0.001059 seconds (2.04 k allocations: 102.094 KiB)
  0.041027 seconds (93.77 k allocations: 4.510 MiB)
  0.000500 seconds (938 allocations: 48.906 KiB)
  0.000929 seconds (1.54 k allocations: 77.656 KiB)
  0.008784 seconds (18.34 k allocations: 887.688 KiB)
  0.001253 seconds (2.36 k allocations: 117.906 KiB)
  0.003251 seconds (6.16 k allocations: 301.188 KiB)
  0.004738 seconds (10.14 k allocations: 490.219 KiB)
  0.001110 seconds (2.16 k allocations: 107.844 KiB)
  0.004900 seconds (10.15 k allocations: 491.656 KiB)
  0.010957 seconds (22.95 k allocations: 1.086 MiB)
  0.025079 seconds (52.75 k allocations: 2.492 MiB)
  0.000063 seconds (68 allocations: 7.219 KiB)
  0.129393 seconds (86.98 k allocations: 4.153 MiB, 71.58% gc time)
...
```
