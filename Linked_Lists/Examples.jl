include("./LinkedLists.jl")
include("../Utilties/utils.jl")

# DASHBOARD
num=[1,10, 50,100,500,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000]
N=length(num);
lists=map( x-> LinkedList(1:x), num);
result_lists(time_list,filename,funcname;label="")=print_results(num,time_list;
    title="Time to compute $funcname",
    filename="Linked_Lists/$filename.svg",
    label=label)

iscomputed(filename)=isfile("Linked_Lists/$filename.svg") && !getredo()



# Example 1: Length of a List
funcname="length List"
filename="ListLength"

time_length=Vector{Float64}(undef,N);


if !iscomputed(filename)
    for (i,list) in enumerate(lists)
        time_length[i]=benchmarking(length,list);
    end
    result_lists(time_length,filename,funcname)
end


# Example 2: Pushing an element in the list
funcname="Push List"
filename="ListPush"
label=["pushfirst!" "push!" "pushat!"]

time_push=Matrix{Float64}(undef,N,3);

if !iscomputed(filename)
    for (i,(n,list)) in enumerate(zip(num,lists))
        time_push[i,1]=benchmarking(pushfirst!,list,n=1);
        time_push[i,2]=benchmarking(push!,list,n=1);
        time_push[i,3]=benchmarking(pushat!,list,n=1,i=Int(ceil(n/2)));
    end

    result_lists(time_push,filename,funcname;label=label)
end

# Example 3: Popping an element in the list
funcname="Pop List"
filename="ListPop"
label=["popfirst!" "pop!" "popat!"]

time_pop=Matrix{Float64}(undef,N,3);

if !iscomputed(filename)
    for (i,(n,list)) in enumerate(zip(num,lists))
        time_pop[i,1]=benchmarking(popfirst!,list);
        time_pop[i,2]=benchmarking(pop!,list);
        time_pop[i,3]=benchmarking(popat!,list,i=Int(ceil(n/2)));
    end

    result_lists(time_pop,filename,funcname)
end
