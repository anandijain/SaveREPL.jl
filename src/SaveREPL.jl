module SaveREPL

using REPL, InteractiveUtils

export saveREPL
export printREPL
export copyREPL

struct REPLEntry
    time::String
    mode::String
    command::String
end

"""
    saveREPL(filename::String, n::Int=10)

Save `n` last executed Julia commands to script file `filename`.

Order: oldest command first. Ignores help and shell mode commands as well as 
`printREPL` and `saveREPL` calls.
"""
function saveREPL(filename::String, n::Int=10)
    open(filename, "w") do f
        entries = history(n+1)
        write(f, join((x->x.command).(entries[1:end-1]), "\n"))
    end
    nothing
end

function saveREPL(io, n::Int=10)
    entries = history(n+1)
    for e in entries[1:end-1]
        write(io, e.command, "\n")
    end
end

"""
    printREPL(n::Int=10)

Prints the `n` last executed Julia commands.

Order defaults from old to new.
"""
function printREPL(n::Int=10)
    entries = history(n+1)
    for e in entries[1:end-1]
        println(e.command)
    end
    nothing
end

function copyREPL(n::Int=10)
    io = IOBuffer()
    saveREPL(io, n)
    clipboard(String(take!(io)))
end

"""
    history(n::Int)

Load last `n` executed Julia commands from `.julia_history` file.
"""
function history(n::Int)
    h = reverse(readlines(REPL.find_hist_file()))
    entries = REPLEntry[]
    i = 1
    N = length(h)
    c = 0
    while i<=N && c<n
        line = h[i]
        !contains(line, "saveREPL(") || (begin i+=1; continue; end)
        !contains(line, "printREPL(") || (begin i+=1; continue; end)

        cmdlines = String[]
        while startswith(line, "\t")
            push!(cmdlines, replace(line, "\t"=>""; count=1))
            i+=1
            line = h[i]
        end
        command = join(reverse(cmdlines), "\n")

        contains(line, "# mode:") || warn("wrong order: expected mode")
        mode = replace(chomp(line), "# mode: "=>"")

        i+=1
        line = h[i]
        contains(line, "# time: ") || warn("wrong order: expected time")
        time = replace(chomp(line), "# time: "=>"")
        i+=1

        contains(mode, "julia") || continue
        push!(entries, REPLEntry(time, mode, command))
        c+=1
    end
    return reverse(entries)
end

end # module
