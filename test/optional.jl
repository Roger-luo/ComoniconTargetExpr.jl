module TestLeafOptionalArgument

using ComoniconTypes
using ComoniconTargetExpr
using ComoniconTargetExpr: emit_expr, emit_body, emit_norm_body, emit_dash_body
using Test

function foo(a, b=2)
    @test a == 3
end

cmd = Entry(;
    version=v"1.2.0",
    root=LeafCommand(;
        fn=foo,
        name="leaf",
        args=[
            Argument(;name="a", type=Int),
            Argument(;name="b", type=Int, require=false),
        ],
    )
)

eval(emit_expr(cmd))

@testset "test lead optional argument" begin
    @test command_main(["3"]) == 0
    @test command_main(["3", "5"]) == 0
end

end
