using Plots
import Base

# Define a node in the linked list
mutable struct ListNode{T}
    value::Union{T,Nothing}
    next::Union{ListNode, Nothing}
    ListNode(value,pointer) = new{typeof(value)}(value, pointer)
end
ListNode(value) = ListNode(value, nothing)
value(node::ListNode) = node.value
next(node::ListNode) = node.next
Base.show(io::IO, node::ListNode) = begin
    while !isnothing(node)
        println(io, node.value)
        node = node.next
    end
end

# Define the linked list
mutable struct LinkedList{T}
    head::Union{ListNode{T},Nothing}
end
# Sequential Constructor
LinkedList(x::T) where T = LinkedList{T}(ListNode(x))  # Constructor for a single element

function LinkedList(arrx::AbstractVector{T}) where T
    head=ListNode(arrx[firstindex(arrx)])
    node=head
    for x in arrx[firstindex(arrx)+1:end]
        node.next=ListNode(x)
        node=node.next
    end
    return LinkedList(head)
end
Base.show(io::IO, list::LinkedList{T}) where T = begin
    print(io,list.head)
end


Base.length(node::ListNode) = begin
    count = 0;
    while !isnothing(node)
        count += 1
        node = node.next;
    end
    return count
end
Base.length(list::LinkedList) = Base.length(list.head)



Base.:(==)(x::AbstractVector{T},y::ListNode{T}) where T= begin
    length(x)==length(y) || throw(AssertionError("The length of the list is not the same as the length of the vector"))
    for v in x
        y.value==v || return false
        y= y.next
    end
    return true
end
Base.:(==)(x::ListNode{T},y::AbstractVector{T}) where T = Base.:(==)(y,x)
Base.:(==)(x::AbstractVector{T},y::LinkedList{T}) where T = Base.:(==)(x,y.head)
Base.:(==)(x::LinkedList{T},y::AbstractVector{T}) where T = Base.:(==)(y,x)

Base.isempty(list::LinkedList) = isnothing(list.head)

@inline function Base.getindex(list::LinkedList, i::Int)
    N=length(list)
    1<=i<=N || throw(BoundsError(list,i))
    node = list.head
    for _ in 2:i
        node = next(node)
    end
    return value(node)
end

@inline function Base.iterate(list::LinkedList, i::Integer=1)
    i== length(list)+1 ? nothing : (Base.getindex(list,i),i+1)
end
list=LinkedList(1:10)



@inline Base.pushfirst!(list::LinkedList, value) = begin
    new_node = ListNode(value,list.head);
    list.head = new_node;
    return list
end


@inline Base.push!(list::LinkedList, value) = begin
    node = list.head
    while !isnothing(node.next)
        node = node.next
    end
    node.next = ListNode(value)
    return list
end

@inline pushat!(list::LinkedList, value, i::Int) = begin
    N=length(list)
    1<=i<=N+1 || throw(BoundsError(list,i))
    if i==1
        return Base.pushfirst!(list,value)
    end
    if i==N+1
        return Base.push!(list,value)
    end

    node = list.head
    for _ in 2:i-1
        node = node.next
    end
    new_node = ListNode(value,node.next)
    node.next = new_node
    return list
end

@inline push(list::LinkedList, value, i::Int) = begin

    pushat!(list,value,i)
end


Base.popfirst!(list::LinkedList) = begin
    isempty(list) && throw(ArgumentError("list must be not empty"))
    val=value(list.head)
    list.head = list.head.next
    return val
end

Base.pop!(list::LinkedList) = begin
    isempty(list) && throw(ArgumentError("list must be not empty"))
    if length(list)==1
        return Base.popfirst!(list)
    end
    node = list.head
    while !isnothing(node.next.next) #look 2 steps ahead before updating the next pointer
        node = node.next
    end
    val=value(node.next)
    node.next = nothing
    return val
end


Base.popat!(list::LinkedList, i::Int) = begin
    N=length(list)
    1<=i<=N || throw(BoundsError(list,i))
    if i==1
        return Base.popfirst!(list)
    end
    if i==N
        return Base.pop!(list)
    end
    node = list.head
    for _ in 2:i-1
        node = node.next
    end
    val=value(node.next)
    node.next = node.next.next
    return val
end
