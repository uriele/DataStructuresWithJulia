include("./LinkedLists.jl")
include("../Utilties/utils.jl")

# DASHBOARD
num=[1,10, 50,100,150,200,250,300,350,400,500,1000,2000]
N=length(num);
slists=map( x-> SingleLinkedList(1:x), num);
dlists=map( x-> DoubleLinkedList(1:x), num);
cslists=map( x-> CircularSingleLinkedList(1:x), num);
cdlists=map( x-> CircularDoubleLinkedList(1:x), num);
result_lists(time_list,filename,funcname;label="")=print_results(num,time_list;
    title="Time to compute $funcname",
    filename="Linked_Lists/$filename.svg",
    label=label)

iscomputed(filename)=isfile("Linked_Lists/$filename.svg") && !getredo()



# Example 1: Length of a List
funcname="length List"

function test_length(lists,funcname,filename,num=num)
    time_length=Vector{Float64}(undef,length(num));
    for (i,list) in enumerate(lists)
        time_length[i]=benchmarking(length,list.head);
    end
    result_lists(time_length,filename,funcname)
end

test_length(slists,"Length List","SingleListLength")
test_length(dlists,"Length List","DoubleListLength")
test_length(cslists,"Length List","CircularSingleListLength")
test_length(cdlists,"Length List","CircularDoubleListLength")

function test_access(lists,funcname,filename,num=num,
    label=["first" "second" "middle" "beforelast" "last"])
    time_access=Matrix{Float64}(undef,length(num),5);
    for (i,list) in enumerate(lists)
        @show idx1=1
        @show idx2=min(2,num[i]) # if the list is of length 1, we cannot access the second element
        @show idx3=ceil(Int,num[i]/2)
        @show idx4=max(1,num[i]-1) # if the list is of length 1, we cannot access the second element
        @show idx5=num[i]
        time_access[i,1]=benchmarking(x-> x[idx1],list);
        time_access[i,2]=benchmarking(x-> x[idx2],list);
        time_access[i,3]=benchmarking(x-> x[idx3],list);
        time_access[i,4]=benchmarking(x-> x[idx4],list);
        time_access[i,5]=benchmarking(x-> x[idx5],list);
    end
    result_lists(time_access,filename,funcname;label=label)
end

test_access(slists,"Access List","SingleListAccess")
test_access(dlists,"Access List","DoubleListAccess")
test_access(cslists,"Access List","CircularSingleListAccess")
test_access(cdlists,"Access List","CircularDoubleListAccess")

# Example 2: Pushing an element in the list
funcname="Push List"
label=["pushfirst!" "push!" "pushat!"]

#if !iscomputed(filename)
function test_push(lists,funcname,filename,label,num=num)
    timev=Matrix{Float64}(undef,length(num),3);
    for (i,(n,list)) in enumerate(zip(num,lists))
        timev[i,1]=benchmarking(pushfirst!,list,n=1);
        timev[i,2]=benchmarking(push!,list,n=1);
        timev[i,3]=benchmarking(pushat!,list,n=1,i=Int(ceil(n/2)));
    end
    result_lists(timev,filename,funcname;label=label)
end

test_push(slists,"Push List","SingleListPush",label)
test_push(dlists,"Push List","DoubleListPush",label)
test_push(cslists,"Push List","CircularSingleListPush",label)
test_push(cdlists,"Push List","CircularDoubleListPush",label)

# Example 3: Popping an element in the list
funcname="Pop List"
label=["popfirst!" "pop!" "popat!"]

function test_pop(lists,funcname,filename,label,num=num)
    timev=Matrix{Float64}(undef,length(num),3);
    for (i,(n,list)) in enumerate(zip(num,lists))
        timev[i,1]=benchmarking(popfirst!,list);
        timev[i,2]=benchmarking(pop!,list);
        timev[i,3]=benchmarking(popat!,list,i=Int(ceil(n/2)));
    end
    result_lists(timev,filename,funcname;label=label)
end

test_pop(slists,"Pop List","SingleListPop",label)
test_pop(dlists,"Pop List","DoubleListPop",label)
test_pop(cslists,"Pop List","CircularSingleListPop",label)
test_pop(cdlists,"Pop List","CircularDoubleListPop",label)
