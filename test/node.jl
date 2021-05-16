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
