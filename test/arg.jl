module TestLeafArgument

using ComoniconTypes
using ComoniconTargetExpr
using ComoniconTargetExpr: emit_expr, emit_body, emit_norm_body, emit_dash_body
using Test

function foo(a::Int)
    @test a == 3
end

cmd = CLIEntry(;
    version=v"1.1.0",
    root=LeafCommand(;
        fn=:foo,
        name="leaf",
        args=[
            Argument(;name="a", type=Int),
        ]
    )
)

eval(emit_expr(cmd))

@testset "test leaf argument" begin
    @test command_main(["3"]) == 0
    @test command_main(["1.2"]) == 1
end

end
