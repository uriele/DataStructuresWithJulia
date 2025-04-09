# What is a priority queue
When we need to find the min/max element among a collection of elements, we can do it using the priority queue ADT.
Supports the operation of 
- `Insert`
- `DeleteMin`: delete and return the deleted element
- `DeleteMax`: delete and return the maximum element

This is similar to the `EnQueue` and `DeQueue` operation of a `queue`, the main difference is that the order in which the elements enters into the queue is not necessarily the order in which they are processed

One use case is the job scheduling, where the jobs are executed in order of priority

# Abstract Data Type

## Main Operations
The priority queue is a container of elements, each having an associated `key`
- `Insert(key,data)`: insert element with `key`, elements are ordered by `key`
- `DeleteMin/DeleteMax`: remove and return the smallest/largest key
- `GetMinimimum/GetMaximum`: return the smallest/largest element (by key) without deleting it

## Auxiliary Operations
- `kth-smallest/kth-largest`: return the kth smallest\lartest key in the priority queue
- `size`: return the total number of elements in the priority queue
- `heap sort`: sort the elements in the queue by key

# Possible Applications
- `Data compression`: for example Huffman coding 
- `Shortest path alghoritms`: Dijkstra or Fast Marching algorithm
- `Minimum spanning tree`: Prim's Algorithm
- `Event driven simulation`
- `Selection problems`

# Possible Implementations
## Array
Elements are inserted in an unordered fashion. Deletion are performed by looking for the key and deleting the element.

- **insertion complexity**: O(1)
- **DeleteMin complexity**: O(N)

## Unordered List
similar to array but using linked lists
- **insertion complexity**: O(1)
- **DeleteMin complexity**: O(N)

## Ordered Array
Elements are inserted in an ordered fashion, deletion on a single end
- **insertion complexity**: O(N)
- **DeleteMin complexity**: O(1)

## Ordered List
Similar to linked list but deletion only on one side, all the orther function of a linked list stays. Circular Double Linked List could delete both min and max
- **insertion complexity**: O(N)
- **DeleteMin complexity**: O(1)

# Binary Search Tree implementation
If insertion are random, both insertion and deletion happens in O(NlogN)
- **insertion complexity**: O(NlogN)
- **DeleteMin complexity**: O(NlogN)



