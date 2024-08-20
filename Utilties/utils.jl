using Plots

using BenchmarkTools
const REDOALL=Ref(false)

setredo(x::Bool)=REDOALL[]=x
getredo()=REDOALL[]
@inline function benchmarking(f::Function, val;kwargs...)
    if isempty(kwargs)
        return time(mean(@benchmark($f(a,values($kwargs)...); setup=(a=deepcopy($val)), evals=1)))
    else
        return time(mean(@benchmark($f(a,values($kwargs)...); setup=(a=deepcopy($val)), evals=1)))
    end
end

function print_results(N,time_list;title="Time to compute the length of a list",filename="ListLength.svg",label="")
    p=plot(N,time_list,label=label)
    scatter!(N,time_list,label="")
    yaxis!("Time (ns)")
    xaxis!("N")
    title!(title)
    savefig(filename)
    return display(p)
end

print_results(time_list;kwargs...)= print_results(1:length(time_list),time_list;kwargs...)
