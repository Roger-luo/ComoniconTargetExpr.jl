module TestNodeCommand

using ComoniconTypes
using ComoniconTargetExpr
using ComoniconTargetExpr: emit_expr, emit_body, emit_norm_body, emit_dash_body
using Test

function called()
    @test true
end

cmd = CLIEntry(;
    version=v"1.2.0",
    root=NodeCommand(;
        name="node",
        subcmds=Dict(
            "cmd1" => LeafCommand(;
                fn=called,
                name="cmd1",
            ),
            "cmd2" => LeafCommand(;
                fn=called,
                name="cmd2",
            )
        )
    )
)

eval(emit_expr(cmd))

@testset "test node" begin
    @test command_main(["cmd3"]) == 1
    @test command_main(["cmd1", "foo"]) == 1
    @test command_main(["cmd1", "foo", "-h"]) == 0
    @test command_main(["cmd1", "foo", "-V"]) == 0
end

end

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

module TestLeafOptionalArgument

using ComoniconTypes
using ComoniconTargetExpr
using ComoniconTargetExpr: emit_expr, emit_body, emit_norm_body, emit_dash_body
using Test

function foo(a, b=2)
    @test a == 3
end

cmd = CLIEntry(;
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

module TestLeafVararg

using ComoniconTypes
using ComoniconTargetExpr
using ComoniconTargetExpr: emit_expr, emit_body, emit_norm_body, emit_dash_body
using Test

function foo(a, b=2, c...)
    @test a == 3
end

cmd = CLIEntry(;
    version=v"1.1.0",
    root=LeafCommand(;
        fn=foo,
        name="leaf",
        args=[
            Argument(;name="a", type=Int),
            Argument(;name="b", type=Int, require=false),
        ],
        vararg=Argument(;name="c", type=Float64, vararg=true),
    )
)

eval(emit_expr(cmd))

@testset "test leaf optional argument" begin
    @test command_main(["3", "2", "5", "6", "7"]) == 0
    @test command_main(["3", "2"]) == 0
end

end
