using Plots
import Base


abstract type AbstractListNode{T} end
# Define a node in the linked list

mutable struct SingleListNode{T}<:AbstractListNode{T}
    value::Union{T,Nothing}
    next::Union{SingleListNode, Nothing}
    SingleListNode(value,pointer) = new{typeof(value)}(value, pointer)
end
SingleListNode(value) = SingleListNode(value, nothing)

# Define the double linked list node in the simple way
mutable struct DoubleListNode{T}<:AbstractListNode{T}
    value::Union{T,Nothing}
    next::Union{DoubleListNode, Nothing}
    prev::Union{DoubleListNode, Nothing}
    DoubleListNode(value,pointer_next=nothing,pointer_previous=nothing) = new{typeof(value)}(value, pointer_next, pointer_previous)
end
DoubleListNode(value;previous=nothing,next=nothing) = begin
    newnode=DoubleListNode(value,next,previous)
    !isnothing(previous) && (previous.next=newnode)
    return newnode
end
value(::Nothing) = nothing
value(node::AbstractListNode) = node.value
next(node::AbstractListNode) = node.next
prev(::AbstractListNode) = nothing
prev(node::DoubleListNode) = node.prev


Base.show(io::IO, node::AbstractListNode) = begin
    head=node
    while !isnothing(node)
        println(io, value(node))
        node = next(node)
        head===node && break
    end
end

abstract type AbstractLinkedList{T,N<:AbstractListNode} end
# Define the linked list
mutable struct LinkedList{T,N}<:AbstractLinkedList{T,N}
    head::Union{N,Nothing}
    _length::Int
end

mutable struct CircularLinkedList{T,N}<:AbstractLinkedList{T,N}
    head::Union{N,Nothing}
    _length::Int
end



next(list::AbstractLinkedList) = next(list.head)
value(list::AbstractLinkedList) = value(list.head)
prev(list::AbstractLinkedList) = nothing
prev(list::AbstractLinkedList{T,DoubleListNode}) where T = prev(list.head)

LinkedList(x::T, ::Type{N}) where {T, N<:AbstractListNode} = LinkedList{T,N}(N(x),1)
function LinkedList(arrx::AbstractArray{T}, ::Type{N}) where {T, N<:AbstractListNode}
    length(arrx)==0 && throw(ArgumentError("The array must have at least one element"))
    length(arrx)==1 && return LinkedList(first(arrx),N)
    head = N(arrx[firstindex(arrx)])
    node = head
    for x in arrx[firstindex(arrx)+1:end]
        node=next_node!(node,x)
    end
    LinkedList{T,N}(head,length(arrx))
end

@inline close_loop!(last_node::SingleListNode, head::SingleListNode) = begin
    last_node.next = head
end
@inline close_loop!(last_node::DoubleListNode, head::DoubleListNode) = begin
    last_node.next = head
    head.prev = last_node
end


CircularLinkedList(x::T, ::Type{N}) where {T, N<:AbstractListNode} = begin
    head = N(x)
    close_loop!(head,head)
    return CircularLinkedList{T,N}(head,1)
end

function CircularLinkedList(arrx::AbstractArray{T}, ::Type{N}) where {T, N<:AbstractListNode}
    length(arrx)==0 && throw(ArgumentError("The array must have at least one element"))
     length(arrx)==1 && return CircularLinkedList(first(arrx),N)
    head = N(arrx[firstindex(arrx)])
    node = head
    for x in arrx[firstindex(arrx)+1:end]
        node=next_node!(node,x)
    end
    close_loop!(node,head)
    return CircularLinkedList{T,N}(head,length(arrx))
end


# It has the bang because it modifies the current node but it returns the next node
next_node!(node::SingleListNode, value) = begin
    node.next = SingleListNode(value)
    return node.next
end
next_node!(node::DoubleListNode, value) = begin
    node.next = DoubleListNode(value;previous=node)
    return node.next
end


const SingleLinkedList{T}  = LinkedList{T,SingleListNode}
const DoubleLinkedList{T}  = LinkedList{T,DoubleListNode}
const CircularSingleLinkedList{T}  = CircularLinkedList{T,SingleListNode}   # Circular linked list
const CircularDoubleLinkedList{T}  = CircularLinkedList{T,DoubleListNode}   # Circular linked list


SingleLinkedList(x::T, ::Type{SingleListNode}) where T = LinkedList(x,SingleListNode)  # Constructor for a single element
SingleLinkedList(x) = SingleLinkedList(x, SingleListNode)
DoubleLinkedList(x::T, ::Type{DoubleListNode}) where T = LinkedList(x,DoubleListNode)  # Constructor for a single element
DoubleLinkedList(x) = DoubleLinkedList(x, DoubleListNode)

CircularSingleLinkedList(x::T, ::Type{SingleListNode}) where T = CircularLinkedList(x,SingleListNode)  # Constructor for a single element
CircularSingleLinkedList(x) = CircularSingleLinkedList(x, SingleListNode)
CircularDoubleLinkedList(x::T, ::Type{DoubleListNode}) where T = CircularLinkedList(x,DoubleListNode)  # Constructor for a single element
CircularDoubleLinkedList(x) = CircularDoubleLinkedList(x, DoubleListNode)


Base.show(io::IO, list::AbstractLinkedList{T}) where T = begin
    print(io,list.head)
end


Base.length(node::AbstractListNode) = begin
    count = 0;
    head=node; # for CircularLinkedList
    while !isnothing(node)
        count += 1
        node = next(node);
        node===head && break
    end
    return count
end
Base.length(list::AbstractLinkedList) = list._length


Base.:(==)(node_x::NL1,node_y::NL2) where {T1,T2,NL1<:AbstractListNode{T1},NL2<:AbstractListNode{T2}} = begin
    length(node_x)==length(node_y) || return false
    head=node_x
    while !isnothing(node_x)
        value(node_x)==value(node_y) || return false
        node_x = next(node_x)
        node_y = next(node_y)
        head===node_x && break
    end
    return true
end

Base.:(==)(list1::AbstractLinkedList{T1,NL1},list2::AbstractLinkedList{T2,NL2}) where {T1,T2,NL1<:AbstractListNode,NL2<:AbstractListNode} = Base.:(==)(list1.head,list2.head)

Base.:(==)(x::T,node_y::AbstractListNode{T}) where T = begin
    length(x)==1 || return false
    return value(node_y)==x
end
Base.:(==)(node_y::AbstractListNode{T},x::T) where T = Base.:(==)(x,node_y)


Base.:(==)(x::AbstractVector{T},node_y::AbstractListNode{T}) where T= begin
    length(x)==length(node_y) || throw(AssertionError("The length of the list is not the same as the length of the vector"))
    for v in x
        value(node_y)==v || return false
        node_y= next(node_y)
    end
    return true
end
Base.:(==)(node_y::AbstractListNode{T},x::AbstractVector{T}) where T = Base.:(==)(x,node_y)
Base.:(==)(x::AbstractListNode{T},y::AbstractVector{T}) where T = Base.:(==)(y,x)
Base.:(==)(x::AbstractVector{T},y::AbstractLinkedList{T}) where T = Base.:(==)(x,y.head)
Base.:(==)(x::AbstractLinkedList{T},y::AbstractVector{T}) where T = Base.:(==)(y,x)
Base.:(==)(x::T,y::AbstractLinkedList{T}) where T = Base.:(==)(x,y.head)
Base.:(==)(x::AbstractLinkedList{T},y::T) where T = Base.:(==)(y,x)

Base.isempty(list::AbstractLinkedList) = isnothing(list.head)



@inline function Base.getindex(list::AbstractLinkedList, i)
    # N=length(list) # expensive operation
    # 1<=i<=N || throw(BoundsError(list,i))
    node=first(list)
    i==1 && return node
    N=length(list)
    1<=i<=N || throw(BoundsError("index out of bounds"))
    return loop_over(list,i,N)

end
@inline loop_over(list::AbstractLinkedList, i::Int,N::Int) = begin
    node=first(list)
    for _ in 2:i
        node=next(node)
    end
    return node
end
@inline loop_over(list::CircularDoubleLinkedList, i::Int,N::Int) = begin
    i==N && return node=last(list)
    if i<=N/2
        node=first(list)
        for _ in 2:i
            node=next(node)
        end
        return node
    else
        node=last(list)
        for _ in 1:N-i
            node=prev(node)
        end
        return node
    end
end


@inline Base.lastindex(list::AbstractLinkedList) = length(list)
@inline Base.firstindex(list::AbstractLinkedList) = 1
@inline Base.first(list::AbstractLinkedList) = list.head
@inline Base.last(list::AbstractLinkedList) = list[end]
@inline Base.last(list::CircularDoubleLinkedList) = prev(list.head)


@inline function Base.iterate(list::AbstractLinkedList, i::Int=1)
    i== length(list)+1 ? nothing : (Base.getindex(list,i),i+1)
end


@inline function update_nodes!(new_node::SingleListNode,node_left::SingleListNode, node_right::SingleListNode)
    new_node.next = node_right
    node_left.next = new_node
    return new_node
end
@inline function update_nodes!(new_node::SingleListNode,node_left::SingleListNode, ::Nothing)
    node_left.next = new_node
    return new_node
end
@inline function update_nodes!(new_node::AbstractListNode, ::Nothing, node_right::SingleListNode)
    new_node.next = node_right
    return new_node
end

@inline function update_nodes!(new_node::DoubleListNode,node_left::DoubleListNode, node_right::DoubleListNode)
    new_node.next = node_right
    new_node.prev = node_left
    node_left.next = new_node
    node_right.prev = new_node
    return new_node #return the left
end
@inline function update_nodes!(new_node::DoubleListNode,node_left::DoubleListNode, ::Nothing)
    new_node.prev = node_left
    new_node.next = nothing
    node_left.next = new_node
    return new_node
end
@inline function update_nodes!(new_node::AbstractListNode, ::Nothing, node_right::DoubleListNode)
    new_node.prev = nothing
    new_node.next = node_right
    node_right.prev = new_node
    return new_node
end


@inline function update_nodes!(left_node::AbstractListNode, right_node::AbstractListNode)
    left_node.next = right_node
    return left_node
end
@inline function update_nodes!(left_node::DoubleListNode, right_node::DoubleListNode)
    left_node.next = right_node
    right_node.prev = left_node
    return left_node
end

@inline update_nodes!(::Nothing, right_node::AbstractListNode) = right_node
@inline update_nodes!(::Nothing, right_node::DoubleListNode) = begin
    right_node.prev=nothing
    return right_node
end

@inline update_nodes!(left_node::AbstractListNode, ::Nothing) = begin
    left_node.next=nothing
    return left_node
end

@inline update_nodes!(::Nothing, ::Nothing) = nothing



@inline Base.pushfirst!(list::LinkedList{T,NL}, value::T) where {T,NL<:AbstractListNode} = begin
    new_node = NL(value);
    head=first(list)
    list.head=update_nodes!(new_node,nothing,head);
    list._length+=1
    return list
end


@inline Base.pushfirst!(list::CircularLinkedList{T,NL}, value::T) where {T,NL<:AbstractListNode} = begin
    new_node = NL(value);
    head=first(list)
    tail=last(list)
    list.head=update_nodes!(new_node,tail,head);
    list._length+=1
    return list
end

@inline Base.pushfirst!(list::CircularDoubleLinkedList{T}, value::T) where {T} = begin
    new_node = DoubleListNode(value);
    head=first(list)
    tail=prev(list)
    list.head=update_nodes!(new_node,tail,head);
    list._length+=1
    return list
end


@inline Base.push!(list::LinkedList{T,NL}, value::T) where {T,NL<:AbstractListNode} = begin

    new_node = NL(value)
    tail=last(list)
    update_nodes!(new_node,tail,nothing)
    list._length+=1
    return list
end

@inline Base.push!(list::CircularSingleLinkedList{T}, value::T) where {T} = begin

    head =first( list)
    new_node = SingleListNode(value)
    tail=last(list)
    update_nodes!(new_node,tail,head)
    list._length+=1
    return list
end

@inline Base.push!(list::CircularDoubleLinkedList{T}, value::T) where {T} = begin
    head =first( list)
    new_node = DoubleListNode(value)
    tail=prev(head)
    update_nodes!(new_node,tail,head)
    list._length+=1
    return list
end

@inline pushat!(list::AbstractLinkedList{T,NL}, value::T, i::Int) where {T,NL<:AbstractListNode} = begin
    N=length(list)
    1<=i<=N+1 || throw(BoundsError(list,i))
    if i==1
        return Base.pushfirst!(list,value)
    end
    if i==N+1
        return Base.push!(list,value)
    end

    node=list[i-1]
    new_node = NL(value)
    update_nodes!(new_node,node,next(node))
    list._length+=1
    return list
end

@inline function delete_node!(node::AbstractListNode)
    node.next = nothing
    return value(node)
end
@inline function delete_node!(node::DoubleListNode)
    node.next = nothing
    node.prev = nothing
    return value(node)
end

Base.popfirst!(list::LinkedList{T,NL})  where {T,NL<:AbstractListNode} = begin
    isempty(list) && throw(ArgumentError("list must be not empty"))
    old_head = list.head
    new_head = next(list.head)
    list.head = update_nodes!(nothing,new_head)
    list._length-=1
    return delete_node!(old_head)
end


Base.popfirst!(list::CircularSingleLinkedList{T})  where {T} = begin
    isempty(list) && throw(ArgumentError("list must be not empty"))
    old_head = list.head
    new_head = next(list.head)
    tail =last( list)
    update_nodes!(tail,new_head)
    list.head = new_head
    list._length-=1
    return delete_node!(old_head)
end

Base.popfirst!(list::CircularDoubleLinkedList{T})  where {T} = begin
    isempty(list) && throw(ArgumentError("list must be not empty"))
    old_head = list.head
    new_head = next(list.head)
    tail = prev(old_head)
    update_nodes!(tail,new_head)
    list.head = new_head
    list._length-=1
    return delete_node!(old_head)
end

Base.pop!(list::LinkedList{T,NL})  where {T,NL<:AbstractListNode} = begin
    isempty(list) && throw(ArgumentError("list must be not empty"))
    if length(list)==1
        return Base.popfirst!(list)
    end

    prev_node=list[end-1]
    del_node = next(prev_node)
    update_nodes!(prev_node,nothing)
    list._length-=1
    return delete_node!(del_node)
end

Base.pop!(list::CircularLinkedList{T,NL})  where {T,NL<:AbstractListNode} = begin
    isempty(list) && throw(ArgumentError("list must be not empty"))
    if length(list)==1
        return Base.popfirst!(list)
    end
    head=first(list)
    prev_node=list[end-1]
    del_node=next(prev_node)

    update_nodes!(prev_node,head)
    list._length-=1
    return delete_node!(del_node)
end

Base.pop!(list::CircularDoubleLinkedList{T})  where {T} = begin
    isempty(list) && throw(ArgumentError("list must be not empty"))

    first(list)===last(list) && return Base.popfirst!(list)

    head=first(list)
    del_node=prev(head)
    prev_node=prev(del_node)

    update_nodes!(prev_node,head)
    list._length-=1
    return delete_node!(del_node)
end


Base.popat!(list::AbstractLinkedList{T,NL}, i::Int) where {T,NL<:AbstractListNode} = begin
    N=length(list)
    1<=i<=N || throw(BoundsError(list,i))
    if i==1
        return Base.popfirst!(list)
    end
    if i==N
        return Base.pop!(list)
    end
    node=list[i-1]
    del_node = next(node)
    next_node = next(del_node)
    update_nodes!(node,next_node)
    list._length-=1
    return delete_node!(del_node)
end
