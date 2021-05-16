module TestLeafOptions

using ComoniconTypes
using ComoniconTargetExpr
using ComoniconTargetExpr: emit_expr, emit_body, emit_norm_body, emit_dash_body
using Test

function foo(;option_a::Int=2, option_b::Float64=2.0, flag_a::Bool=false, flag_b::Bool=false)
    @test option_a == 3
    @test option_b == 1.2
    @test flag_a
    @test flag_b
end

cmd = CLIEntry(;
    version=v"1.1.0",
    root=LeafCommand(;
        fn=foo,
        name="leaf",
        options=Dict(
            "option-a" => Option(;sym=:option_a, hint="int", type=Int, short=true),
            "option-b" => Option(;sym=:option_b, hint="float64", type=Float64),
        ),
        flags=Dict(
            "flag-a" => Flag(;sym=:flag_a, short=true),
            "flag-b" => Flag(;sym=:flag_b),
        )
    )
)

eval(emit_expr(cmd))

@testset "test leaf options" begin
    command_main(["--option-a=3", "--option-b", "1.2", "-f", "--flag-b"])
    command_main(["-o=3", "--option-b", "1.2", "-f", "--flag-b"])
end

end

