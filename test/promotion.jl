# issue 526
function LVTest(a1, a2)
  res = zero(eltype(a1))
  @turbo for i in eachindex(a1, a2)
    res += a1[i] * a2[i]
  end
  return res
end

@testset "Promotion" begin
    af64 = zeros(Float64, 10)
    af32 = zeros(Float32, 10)
    ai64 = zeros(Int64, 10)
    ai32 = zeros(Int32, 10)

    LVTest(af64, af32) # precompile
    LVTest(af64, ai64)
    LVTest(af64, ai32)
    LVTest(af32, ai64)
    LVTest(af32, ai32)
    LVTest(ai32, ai32)

    inferred(f::F, args...) where {F} = try @inferred f(args...); true catch; false end
    @test inferred(LVTest, af64, af32)
    @test inferred(LVTest, af64, ai64)
    @test inferred(LVTest, af64, ai32)
    @test inferred(LVTest, af32, ai64)
    @test inferred(LVTest, af32, ai32)
    @test inferred(LVTest, ai64, ai32)
end