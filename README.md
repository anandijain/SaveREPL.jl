# SaveREPL

A package to save commands executed in the Julia REPL as script file.

Ignores help and shell mode commands as well as calls to exported functions of the package itself. Based on the `.julia_history` file. 

## Usage

The signature is `saveREPL(filename::String, n::Int=10)` where `n` is the number of commands to save.

```
julia> using SaveREPL

julia> a = 1
1

julia> b = 2
2

julia> a + b
3

julia> for i in 1:10
           @show i
       end
i = 1
i = 2
i = 3
i = 4
i = 5
i = 6
i = 7
i = 8
i = 9
i = 10

julia> s = "Hello!"
"Hello!"

julia> saveREPL("script.jl", 5)
```

This will produce a script "script.jl" with the following content

```
a = 1
b = 2
a + b
for i in 1:10
    @show i
end
s = "Hello!"
```

## Other methods

There is also `printREPL(n::Int=10)` which prints the last `n` Julia commands. Note that in contrast to `saveREPL` latest commands come first.

