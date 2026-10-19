using Test
using TaylorSeries

@testset "Nested TaylorN" begin

    
    inner_space = JetSpace(order=3, variables=[:x, :y, :z])
    outer_space = JetSpace(order=1, variables=[:a, :b, :c, :d])

    inner_vars = variables(inner_space)
    a, b, c, d = variables(eltype(inner_vars), outer_space)
    x, y, z = TaylorSeries._constant_taylorN.(TaylorSeries._scalar_space[], variables(inner_space))

    # FIXME: For now, only check that operations don't throw an exception

    @testset "Basic math" begin
        @test_nowarn a + b
        @test_nowarn a - b
        @test_nowarn 2*a
        @test_nowarn a*2
        @test_nowarn a + 0.2
        @test_nowarn 0.2 + a

        @test_nowarn a*a
        @test_nowarn x*x
        @test_nowarn x^2
        @test_nowarn x^3
        @test_nowarn x/(0.3 + a)
        @test_nowarn sqrt(1 + a)

        @test_nowarn a + b*im

        @test_nowarn abs(a + 1)
        @test_nowarn mod2pi(1 + a)
    end

    @testset "Evaluate" begin
        p = @test_nowarn 42 + 2*a + 4*d + x^2 + a*x
        @test_nowarn p(1,2,3,4)
        @test_nowarn p(1,2,3,4)(1,2,3)

        @test_nowarn constant_term(p)
        @test_nowarn constant_term(constant_term(p))
    end

    @testset "Ordering" begin
        @test_nowarn a < b
        @test_nowarn a < 1.0
    end
end