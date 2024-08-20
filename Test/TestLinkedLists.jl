using Test
include("../Linked_Lists/LinkedLists.jl")

function run_tests()
    # Helper function to create a linked list from an array
    arrx=[1,2,3,4,5]
    x=[1]
    pushval=[-9,9,0]
    at=3
    single_list_vec=SingleLinkedList(arrx)
    single_list_scalar=SingleLinkedList(x)
    double_list_vec=DoubleLinkedList(arrx)
    double_list_scalar=DoubleLinkedList(x)
    # add CircularLinkedList
    circular_single_list_vec=CircularSingleLinkedList(arrx)
    circular_single_list_scalar=CircularSingleLinkedList(x)
    circular_double_list_vec=CircularDoubleLinkedList(arrx)
    circular_double_list_scalar=CircularDoubleLinkedList(x)


    @testset "Test Equality" begin
        @test single_list_vec == arrx
        @test single_list_scalar == x[1]
        @test double_list_vec == arrx
        @test double_list_scalar == x[1]
        @test single_list_vec == double_list_vec
        @test single_list_scalar == double_list_scalar
        @test circular_single_list_vec == arrx
        @test circular_single_list_scalar == x[1]
        @test circular_double_list_vec == arrx
        @test circular_double_list_scalar == x[1]
        @test single_list_vec != reverse(arrx)
        @test single_list_scalar != -x[1]
        @test double_list_vec != reverse(arrx)
        @test double_list_scalar != -x[1]
        @test circular_single_list_vec != reverse(arrx)
        @test circular_single_list_scalar != -x[1]
        @test circular_double_list_vec != reverse(arrx)
        @test circular_double_list_scalar != -x[1]
    end

    @testset "Test Push" begin
        push!(single_list_vec, pushval[1])
        push!(single_list_scalar, pushval[1])
        push!(double_list_vec, pushval[1])
        push!(double_list_scalar, pushval[1])
        push!(circular_single_list_vec, pushval[1])
        push!(circular_single_list_scalar, pushval[1])
        push!(circular_double_list_vec, pushval[1])
        push!(circular_double_list_scalar, pushval[1])
        @test single_list_vec == [arrx; pushval[1]]
        @test single_list_scalar == [x[1]; pushval[1]]
        @test double_list_vec == [arrx; pushval[1]]
        @test double_list_scalar == [x[1]; pushval[1]]
        @test circular_single_list_vec == [arrx; pushval[1]]
        @test circular_single_list_scalar == [x[1]; pushval[1]]
        @test circular_double_list_vec == [arrx; pushval[1]]
        @test circular_double_list_scalar == [x[1]; pushval[1]]
    end

    @testset "Test PushFirst" begin
        pushfirst!(single_list_vec, pushval[2])
        pushfirst!(single_list_scalar, pushval[2])
        pushfirst!(double_list_vec, pushval[2])
        pushfirst!(double_list_scalar, pushval[2])
        pushfirst!(circular_single_list_vec, pushval[2])
        pushfirst!(circular_single_list_scalar, pushval[2])
        pushfirst!(circular_double_list_vec, pushval[2])
        pushfirst!(circular_double_list_scalar, pushval[2])
        @test single_list_vec == [pushval[2]; arrx; pushval[1]]
        @test single_list_scalar == [pushval[2]; x[1]; pushval[1]]
        @test double_list_vec == [pushval[2]; arrx; pushval[1]]
        @test double_list_scalar == [pushval[2]; x[1]; pushval[1]]
        @test circular_single_list_vec == [pushval[2]; arrx; pushval[1]]
        @test circular_single_list_scalar == [pushval[2]; x[1]; pushval[1]]
        @test circular_double_list_vec == [pushval[2]; arrx; pushval[1]]
        @test circular_double_list_scalar == [pushval[2]; x[1]; pushval[1]]
    end

    @testset "Test PushAt" begin
        @show pushat!(single_list_vec, pushval[3],at)
        @show pushat!(single_list_scalar, pushval[3], at)
        @show pushat!(double_list_vec, pushval[3], at)
        @show pushat!(double_list_scalar, pushval[3], at)
        @show pushat!(circular_single_list_vec, pushval[3], at)
        @show pushat!(circular_single_list_scalar, pushval[3], at)
        @show pushat!(circular_double_list_vec, pushval[3], at)
        @show pushat!(circular_double_list_scalar, pushval[3], at)
        @test single_list_vec == [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]; pushval[1]]
        @test single_list_scalar == [pushval[2]; x[1]; pushval[3]; pushval[1]]
        @test double_list_vec == [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]; pushval[1]]
        @test double_list_scalar == [pushval[2]; x[1]; pushval[3]; pushval[1]]
        @test circular_single_list_vec == [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]; pushval[1]]
        @test circular_single_list_scalar == [pushval[2]; x[1]; pushval[3]; pushval[1]]
        @show circular_double_list_vec
        @show [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]; pushval[1]]
        @test circular_double_list_vec == [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]; pushval[1]]
        @test circular_double_list_scalar == [pushval[2]; x[1]; pushval[3]; pushval[1]]

    end

    @testset "Test Pop" begin
        pop!(single_list_vec)
        pop!(single_list_scalar)
        pop!(double_list_vec)
        pop!(double_list_scalar)
        pop!(circular_single_list_vec)
        pop!(circular_single_list_scalar)
        pop!(circular_double_list_vec)
        pop!(circular_double_list_scalar)
        @test single_list_vec == [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]]
        @test single_list_scalar == [pushval[2]; x[1]; pushval[3]]
        @test double_list_vec == [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]]
        @test double_list_scalar == [pushval[2]; x[1]; pushval[3]]
        @test circular_single_list_vec == [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]]
        @test circular_single_list_scalar == [pushval[2]; x[1]; pushval[3]]
        @test circular_double_list_vec == [pushval[2]; arrx[1]; pushval[3]; arrx[2:end]]
        @test circular_double_list_scalar == [pushval[2]; x[1]; pushval[3]]
    end

    @testset "Test PopAt" begin
        popat!(single_list_vec, at)
        popat!(single_list_scalar, at)
        popat!(double_list_vec, at)
        popat!(double_list_scalar, at)
        popat!(circular_single_list_vec, at)
        popat!(circular_single_list_scalar, at)
        popat!(circular_double_list_vec, at)
        popat!(circular_double_list_scalar, at)
        @test single_list_vec == [pushval[2]; arrx[1:end]]
        @test single_list_scalar == [pushval[2]; x[1]]
        @test double_list_vec == [pushval[2]; arrx[1:end]]
        @test double_list_scalar == [pushval[2]; x[1]]
        @test circular_single_list_vec == [pushval[2]; arrx[1:end]]
        @test circular_single_list_scalar == [pushval[2]; x[1]]
        @test circular_double_list_vec == [pushval[2]; arrx[1:end]]
        @test circular_double_list_scalar == [pushval[2]; x[1]]
    end

    @testset "Test PopFirst" begin
        popfirst!(single_list_vec)
        popfirst!(single_list_scalar)
        popfirst!(double_list_vec)
        popfirst!(double_list_scalar)
        popfirst!(circular_single_list_vec)
        popfirst!(circular_single_list_scalar)
        popfirst!(circular_double_list_vec)
        popfirst!(circular_double_list_scalar)
        @test single_list_vec == arrx
        @test single_list_scalar == x[1]
        @test double_list_vec == arrx
        @test double_list_scalar == x[1]
        @test circular_single_list_vec == arrx
        @test circular_single_list_scalar == x[1]
        @test circular_double_list_vec == arrx
        @test circular_double_list_scalar == x[1]
    end

    @testset "Test Length" begin
        @test length(single_list_vec) == length(arrx)
        @test length(single_list_scalar) == length(x)
        @test length(double_list_vec) == length(arrx)
        @test length(double_list_scalar) == length(x)
        @test length(circular_single_list_vec) == length(arrx)
        @test length(circular_single_list_scalar) == length(x)
        @test length(circular_double_list_vec) == length(arrx)
        @test length(circular_double_list_scalar) == length(x)
    end

end

run_tests()
